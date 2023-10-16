export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode auto

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias pull="git pull"
alias c="clear"
alias open="xdg-open"

alias norme="$HOME/delivery/my_github/personnal_scripts/commands/epitech_coding_style.sh . ."
alias push="$HOME/delivery/my_github/personnal_scripts/commands/git-push.sh"
alias branch="$HOME/delivery/my_github/personnal_scripts/commands/git-create_branch.sh"
alias clone="$HOME/delivery/my_github/personnal_scripts/commands/git-clone.sh"
alias test="source $HOME/delivery/my_github/personnal_scripts/commands/create_test_folder.sh"
alias branch="$HOME/delivery/my_github/personnal_scripts/commands/git-create_branch.sh"

if [ -d "$HOME/delivery" ]; then
        cd "$HOME/delivery"
fi
