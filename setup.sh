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
  bitwarden-cli
)
aur_packages=(brave-origin-bin joplin-bin hyprmoncfg)
packages_to_remove=(
  kdenlive
  obs-studio
  moonlight-qt
  xournalpp
  omacut
  obsidian
  docker-buildx
  docker-compose
  ufw-docker
  docker
  lazydocker
)
web_apps_to_remove=(
  YouTube
  'Google Contacts'
  'Google Maps'
  'Google Messages'
  'Google Photos'
  Basecamp
  X
  HEY
  Zoom
  'Xbox Cloud Gaming'
)
tuis_to_remove=(Docker)
plugins=(
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
bitwarden_server=https://vault.smartins.ch
bitwarden_email=s@smartins.ch
bitwarden_session=
gpg_keys=(
  'b9743cdb-7a2a-40d6-a0f6-600ccac59ab9 Samuel Martins.asc'
  '6423f60e-9e4f-4cd3-8043-d9f2dbe6046c private.asc'
)
pet_dir=$HOME/.codex/pets/rem--l1

unlock_bitwarden() {
  case $(bw status | jq -r '.status') in
    unauthenticated) bitwarden_session=$(bw login "$bitwarden_email" --raw) ;;
    locked|unlocked) [[ -n "$bitwarden_session" ]] || bitwarden_session=$(bw unlock --raw) ;;
    *) echo 'Could not determine Bitwarden status.' >&2; return 1 ;;
  esac
}

package_is_installed() {
  pacman -Qq | grep -Fx -- "$1" >/dev/null
}

install_ssh_keys() {
  [[ -f "$HOME/.ssh/personal" && -f "$HOME/.ssh/personal.pub" &&
    -f "$HOME/.ssh/work" && -f "$HOME/.ssh/work.pub" ]] && return

  unlock_bitwarden

  local key_file key item
  for key_item in "personal $personal_key_item" "work $work_key_item"; do
    read -r key item <<<"$key_item"
    [[ -f "$HOME/.ssh/$key" ]] && continue
    key_file=$(mktemp "$HOME/.ssh/.${key}.XXXXXX")
    if ! BW_SESSION=$bitwarden_session bw get item "$item" |
      jq -er '.sshKey.privateKey | select(type == "string" and startswith("-----BEGIN OPENSSH PRIVATE KEY-----"))' >"$key_file"; then
      rm -f "$key_file"
      return 1
    fi
    chmod 600 "$key_file"
    mv "$key_file" "$HOME/.ssh/$key"
  done
  for key in personal work; do
    [[ -f "$HOME/.ssh/$key.pub" ]] || ssh-keygen -y -f "$HOME/.ssh/$key" >"$HOME/.ssh/$key.pub"
    chmod 644 "$HOME/.ssh/$key.pub"
  done
}

install_gpg_keys() {
  local key_dir key_file item filename
  unlock_bitwarden

  key_dir=$(mktemp -d)
  for gpg_key in "${gpg_keys[@]}"; do
    read -r item filename <<<"$gpg_key"
    key_file="$key_dir/$filename"
    if ! BW_SESSION=$bitwarden_session bw get attachment "$filename" --itemid "$item" --output "$key_file" ||
      ! gpg --batch --import "$key_file"; then
      rm -f "$key_file"
      rmdir "$key_dir"
      return 1
    fi
    rm -f "$key_file"
  done
  rmdir "$key_dir"
}

check_setup() {
  local package failed=false
  for package in "${packages[@]}" "${aur_packages[@]}"; do
    package_is_installed "$package" || { echo "missing package: $package"; failed=true; }
  done
  diff -q <(printf '%s\n' "$registry") "$registry_file" &>/dev/null || { echo "missing Podman HTTP registry: $registry_file"; failed=true; }
  diff -q <(printf '%s\n' "$locale") "$locale_file" &>/dev/null || { echo "missing locale configuration: $locale_file"; failed=true; }
  [[ -f "$pet_dir/pet.json" && -f "$pet_dir/spritesheet.webp" ]] || { echo "missing pet: $pet_dir"; failed=true; }
  systemctl --user is-enabled --quiet ssh-agent.socket || { echo 'ssh-agent.socket is not enabled'; failed=true; }
  for key in personal work; do
    [[ -f "$HOME/.ssh/$key" ]] || { echo "missing SSH key: ~/.ssh/$key"; failed=true; }
    [[ -f "$HOME/.ssh/$key.pub" ]] || { echo "missing SSH public key: ~/.ssh/$key.pub"; failed=true; }
  done
  if $failed; then
    return 1
  fi
}

if $check; then
  check_setup
  exit $?
fi

command -v omarchy >/dev/null || { echo 'This setup requires Omarchy.' >&2; exit 1; }
# podman-docker provides the Docker-compatible CLI and conflicts with Docker.
# Remove Docker and packages depending on it before installing Podman.
for package in "${packages_to_remove[@]}"; do
  package_is_installed "$package" && sudo pacman -R --noconfirm "$package"
done
omarchy pkg add "${packages[@]}"
for package in "${aur_packages[@]}"; do
  package_is_installed "$package" || omarchy pkg aur add "$package"
done
[[ $(bw config server) == "$bitwarden_server" ]] || bw config server "$bitwarden_server"
for web_app in "${web_apps_to_remove[@]}"; do
  OMARCHY_REMOVE_NOTIFY=false omarchy webapp remove "$web_app"
done
for tui in "${tuis_to_remove[@]}"; do
  OMARCHY_REMOVE_NOTIFY=false omarchy tui remove "$tui"
done

for plugin in "${plugins[@]}"; do
  read -r id url <<<"$plugin"
  [[ -d "$HOME/.config/omarchy/plugins/$id" ]] || omarchy plugin add "$url" --enable
done

[[ -f "$pet_dir/pet.json" && -f "$pet_dir/spritesheet.webp" ]] ||
  curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/legeling/awesome-codex-pet/main/scripts/install-pet.sh |
    bash -s -- --raw-base https://raw.githubusercontent.com/legeling/awesome-codex-pet/main rem--l1

sudo install -d -m 755 /etc/containers/registries.conf.d
printf '%s\n' "$registry" | sudo tee "$registry_file" >/dev/null
if ! diff -q <(printf '%s\n' "$locale") "$locale_file" &>/dev/null; then
  sudo sed -i -E 's~^#?[[:space:]]*(en_US\.UTF-8 UTF-8|it_CH\.UTF-8 UTF-8)[[:space:]]*$~\1~' /etc/locale.gen
  sudo locale-gen
  printf '%s\n' "$locale" | sudo tee "$locale_file" >/dev/null
fi
systemctl --user enable --now ssh-agent.socket

mkdir -p -m 700 "$HOME/.ssh"
install_ssh_keys
install_gpg_keys
echo 'SSH and GPG keys are restored from Bitwarden; private keys are intentionally not stored here.'
"$repo_dir/setup.sh" --check
