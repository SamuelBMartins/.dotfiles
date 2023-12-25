export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
HIST_STAMPS="dd.mm.yyyy"

zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit

plugins=(
  git
  aws
  podman
  colored-man-pages
  httpie
  rust
#  docker
#  terraform
#  toolbox
#  zsh-autosuggestions
)

if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

source $ZSH/oh-my-zsh.sh

# User configuration
# Variables
# export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

export PATH="${PATH}:${HOME}/Programs/bin:${HOME}/.local/bin"
[ -d "/usr/lib/jvm/java" ] && export JAVA_HOME='/usr/lib/jvm/java'

bindkey -v

# Aliases
if (( $+commands[bat] )); then
  alias cat="bat"
fi

if (( $+commands[exa] )); then
  alias ls="exa"
  alias tree="exa -T"
fi

alias vim="nvim"
alias lg="lazygit"
alias clip "xclip -sel c <"

# dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
compdef dotfiles='git'

# This plugins must be at the end of the file
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
