# .dotfiles

## Setup

```bash
git clone --bare https://github.com/SamuelBMartins/.dotfiles.git "$HOME/.dotfiles"

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout
# If there are errors delete conflicts manually

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" \
    config --local status.showUntrackedFiles no
```

Choose the branch to use (change the value for another machine), then configure
it to track its remote counterpart:

```bash
DOTFILES_BRANCH=laptop

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" \
    config --local remote.origin.fetch "+refs/heads/$DOTFILES_BRANCH:refs/remotes/origin/$DOTFILES_BRANCH"
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" fetch origin
git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" \
    branch --set-upstream-to="origin/$DOTFILES_BRANCH" "$DOTFILES_BRANCH"
```

Then install the packages and Omarchy plugins; it also configures the locale, local DNS server, Podman registry exception, and OpenSSH agent socket:

```bash
./setup.sh
```

`setup.sh` interactively unlocks Bitwarden, downloads both SSH keys, and imports both GPG private keys. Private keys are intentionally not part of this repository or script.
