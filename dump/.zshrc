export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode auto

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias pull="git pull"
alias c="clear"
alias open="xdg-open"

alias test="source $HOME/.config/create_test_folder.sh"
alias norme="$HOME/.config/epitech_coding_style.sh . ."
alias clone="$HOME/.config/git-clone.sh"
alias branch="$HOME/.config/git-create_branch.sh"
alias push="$HOME/.config/git-push.sh"
alias dmouli="$HOME/.config/run_epitest_docker.sh"
