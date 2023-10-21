#!/bin/bash

DIRECTORY_PATH=""

FILE_ZSHRC=".zshrc"
FILE_PRIVATE_KEY="id_ed25519"
FILE_PUBLIC_KEY="id_ed25519.pub"
FILE_SSHS_CONFIG="config"

KEY_FILES=("$PRIVATE_KEY_FILE" "$PUBLIC_KEY_FILE" "$FILE_ZSHRC" "$FILE_SSHS_CONFIG")

clear
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

while true; do
    read -p "Enter the path of the repertory with those files: $PRIVATE_KEY_FILE, $PUBLIC_KEY_FILE, $FILE_ZSHRC, $FILE_SSHS_CONFIG" DIRECTORY_PATH
    if [ ! -d "$DIRECTORY_PATH" ]; then
        echo "The specified path is not available. Please, be sure that the repertory exist."
        continue
    fi

    all_files_exist=true
    for file in "${KEY_FILES[@]}"; do
        if [ ! -f "$DIRECTORY_PATH/$file" ]; then
            echo "The file $file is not present in the specified repertory."
            all_files_exist=false
        fi
    done

    if [ "$all_files_exist" = true ]; then
        break
    fi
done


# setup .zshrc (vérifier que zsh et ohmyzsh sont bien installé avant)
cp "$DIRECTORY_PATH/$FILE_ZSHRC" $HOME/.zshrc
sudo chown $USER $HOME/.zshrc


# setup workspace
mkdir -p $HOME/delivery
mkdir -p $HOME/delivery/my_github


# setup scriptspace
mkdir -p $HOME/.scripts

curl -o $HOME/.scripts/create_test_folder.sh create_test_folder.sh
chmod +x $HOME/.scripts/create_test_folder.sh

curl -o $HOME/.scripts/epitech_coding_style.sh https://raw.githubusercontent.com/RedBoardDev/personnal_scripts/main/commands/epitech_coding_style.sh
chmod +x $HOME/.scripts/epitech_coding_style.sh

curl -o $HOME/.scripts/git-clone.sh https://raw.githubusercontent.com/RedBoardDev/personnal_scripts/main/commands/git-clone.sh
chmod +x $HOME/.scripts/git-clone.sh

curl -o $HOME/.scripts/git-create_branch.sh https://raw.githubusercontent.com/RedBoardDev/personnal_scripts/main/commands/git-create_branch.sh
chmod +x $HOME/.scripts/git-create_branch.sh

curl -o $HOME/.scripts/git-push.sh https://raw.githubusercontent.com/RedBoardDev/personnal_scripts/main/commands/git-push.sh
chmod +x $HOME/.scripts/git-push.sh

curl -o $HOME/.scripts/run_epitest_docker.sh https://raw.githubusercontent.com/RedBoardDev/personnal_scripts/main/commands/run_epitest_docker.sh
chmod +x $HOME/.scripts/run_epitest_docker.sh


# setup ssh
mkdir -p $HOME/.ssh

cp "$DIRECTORY_PATH/$FILE_PRIVATE_KEY" $HOME/.ssh/
cp "$DIRECTORY_PATH/$FILE_PUBLIC_KEY" $HOME/.ssh/
chmod 600 $HOME/.ssh/$FILE_PRIVATE_KEY
chmod 644 $HOME/.ssh/$FILE_PUBLIC_KEY

cp "$DIRECTORY_PATH/$FILE_SSHS_CONFIG" $HOME/.ssh/


# clone epitech repository
if ! which ghs >/dev/null 2>&1; then
    dnf -y install gh
fi
eval "gh auth login"
curl -o $HOME/delivery/clone_all_repository_github.sh https://raw.githubusercontent.com/RedBoardDev/personnal_scripts/main/clone_all_repository_github.sh
chmod +x $HOME/delivery/clone_all_repository_github.sh
cd $HOME/delivery
eval "$HOME/delivery/clone_all_repository_github.sh -o EpitechPromo2026"
rm -rf $HOME/delivery/clone_all_repository_github.sh

# install les services après les avoir tests et voir pour update_discord
