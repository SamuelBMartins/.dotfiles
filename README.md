# .dotfiles

## Setup

```bash
git clone --bare git@github.com:SamuelBMartins/.dotfiles.git .dotfiles
# or:
# git clone https://github.com/SamuelBMartins/.dotfiles.git

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout
# If there are errors delete conflicts manually

git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" \
    config --local status.showUntrackedFiles no
```
