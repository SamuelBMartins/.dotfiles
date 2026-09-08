#!/usr/bin/env bash
# Install the software required by the configuration in this repository.
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
check=false
[[ ${1:-} == --check ]] && check=true
[[ $# -le 1 ]] || { echo "usage: $0 [--check]" >&2; exit 2; }

packages=(
  bitwarden
  git-lfs
  gnupg
  jq
  podman
  podman-compose
  podman-docker
)
aur_packages=(bitwarden-cli-bin blesh brave-origin-bin joplin-bin hyprmoncfg)
plugins=(
  'crmne.hyprmoncfg https://github.com/crmne/omarchy-hyprmoncfg.git'
  'io.github.elevate08.qs-bitwarden-cli https://github.com/Elevate08/qs-bitwarden-cli.git'
  'jkoestinger.vpn https://github.com/jkoestinger/omarchy-vpn.git'
  'mirador https://github.com/sanjyay/Mirador.git'
  'quickshell.spotify https://github.com/stappmus/Omarchy-Spotify.git'
  'raiden-meixelysia.omarchy-pets https://github.com/ZacharyZhang-NY/omarchy-pets.git'
)
registry_file=/etc/containers/registries.conf.d/50-local-registry.conf
registry='[[registry]]
location = "192.168.0.40:23000"
insecure = true'
locale_file=/etc/locale.conf
locale='LANG=en_US.UTF-8
LC_NUMERIC=it_CH.UTF-8
LC_TIME=it_CH.UTF-8
LC_MONETARY=it_CH.UTF-8
LC_PAPER=it_CH.UTF-8
LC_NAME=it_CH.UTF-8
LC_ADDRESS=it_CH.UTF-8
LC_TELEPHONE=it_CH.UTF-8
LC_MEASUREMENT=it_CH.UTF-8'
personal_key_item=f1b61935-ac35-448f-969b-e47a8d989988
work_key_item=ae1ca17c-3aa2-42af-87aa-27795df63c25
gpg_keys=(
  'b9743cdb-7a2a-40d6-a0f6-600ccac59ab9 Samuel Martins.asc'
  '6423f60e-9e4f-4cd3-8043-d9f2dbe6046c private.asc'
)
pet_dir=$HOME/.codex/pets/cute-rem

install_ssh_keys() {
  [[ -f "$HOME/.ssh/personal" && -f "$HOME/.ssh/work" ]] && return

  case $(bw status | jq -r '.status') in
    unauthenticated) bw login ;;
    locked|unlocked) ;;
    *) echo 'Could not determine Bitwarden status.' >&2; return 1 ;;
  esac

  local session key_file key item
  session=$(bw unlock --raw)
  for key_item in "personal $personal_key_item" "work $work_key_item"; do
    read -r key item <<<"$key_item"
    [[ -f "$HOME/.ssh/$key" ]] && continue
    key_file=$(mktemp "$HOME/.ssh/.${key}.XXXXXX")
    if ! BW_SESSION=$session bw get item "$item" |
      jq -er '.sshKey.privateKey | select(type == "string" and startswith("-----BEGIN OPENSSH PRIVATE KEY-----"))' >"$key_file"; then
      rm -f "$key_file"
      return 1
    fi
    chmod 600 "$key_file"
    mv "$key_file" "$HOME/.ssh/$key"
  done
  unset session
}

install_gpg_keys() {
  local session key_dir key_file item filename
  case $(bw status | jq -r '.status') in
    unauthenticated) bw login ;;
    locked|unlocked) ;;
    *) echo 'Could not determine Bitwarden status.' >&2; return 1 ;;
  esac

  session=$(bw unlock --raw)
  key_dir=$(mktemp -d)
  for gpg_key in "${gpg_keys[@]}"; do
    read -r item filename <<<"$gpg_key"
    key_file="$key_dir/$filename"
    if ! BW_SESSION=$session bw get attachment "$filename" --itemid "$item" --output "$key_file" ||
      ! gpg --batch --import "$key_file"; then
      rm -f "$key_file"
      rmdir "$key_dir"
      return 1
    fi
    rm -f "$key_file"
  done
  rmdir "$key_dir"
  unset session
}

check_setup() {
  local package failed=false
  for package in "${packages[@]}" "${aur_packages[@]}"; do
    pacman -Q "$package" &>/dev/null || { echo "missing package: $package"; failed=true; }
  done
  diff -q <(printf '%s\n' "$registry") "$registry_file" &>/dev/null || { echo "missing Podman HTTP registry: $registry_file"; failed=true; }
  diff -q <(printf '%s\n' "$locale") "$locale_file" &>/dev/null || { echo "missing locale configuration: $locale_file"; failed=true; }
  [[ -f "$pet_dir/pet.json" && -f "$pet_dir/spritesheet.webp" ]] || { echo "missing pet: $pet_dir"; failed=true; }
  systemctl --user is-enabled --quiet ssh-agent.socket || { echo 'ssh-agent.socket is not enabled'; failed=true; }
  for key in personal work; do
    [[ -f "$HOME/.ssh/$key" ]] || echo "missing SSH key: ~/.ssh/$key"
  done
  $failed && return 1
}

if $check; then
  check_setup
  exit $?
fi

command -v omarchy >/dev/null || { echo 'This setup requires Omarchy.' >&2; exit 1; }
omarchy pkg add "${packages[@]}"
omarchy pkg aur add "${aur_packages[@]}"

for plugin in "${plugins[@]}"; do
  read -r id url <<<"$plugin"
  [[ -d "$HOME/.config/omarchy/plugins/$id" ]] || omarchy plugin add "$url" --enable
done

[[ -f "$pet_dir/pet.json" && -f "$pet_dir/spritesheet.webp" ]] ||
  curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/legeling/awesome-codex-pet/main/scripts/install-pet.sh |
    bash -s -- --raw-base https://raw.githubusercontent.com/legeling/awesome-codex-pet/main rem--l1

sudo install -d -m 755 /etc/containers/registries.conf.d
printf '%s\n' "$registry" | sudo tee "$registry_file" >/dev/null
sudo sed -i -E 's~^#?[[:space:]]*(en_US\.UTF-8 UTF-8|it_CH\.UTF-8 UTF-8)[[:space:]]*$~\1~' /etc/locale.gen
sudo locale-gen
printf '%s\n' "$locale" | sudo tee "$locale_file" >/dev/null
systemctl --user enable --now ssh-agent.socket

mkdir -p -m 700 "$HOME/.ssh"
install_ssh_keys
install_gpg_keys
echo 'SSH and GPG keys are restored from Bitwarden; private keys are intentionally not stored here.'
"$repo_dir/setup.sh" --check
