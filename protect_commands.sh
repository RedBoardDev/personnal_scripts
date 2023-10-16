#!/bin/bash

# Liste des commandes à sécuriser
commands=("setxkbmap" "crontab" "yes" "xset" "wget" "curl" "dd" "iptables" "ufw")

# Boucle sur chaque commande
for cmd in "${commands[@]}"; do
    # Obtient le chemin complet de la commande
    cmd_path=$(which $cmd 2>/dev/null)

    if [[ -z "$cmd_path" ]]; then
        echo "La commande $cmd n'existe pas sur ce système."
        continue
    fi

    # Renomme le binaire original
    sudo mv "$cmd_path" "${cmd_path}_original"

    # Crée un script d'interposition
    echo "#!/bin/bash" | sudo tee "$cmd_path" > /dev/null
    echo "sudo ${cmd_path}_original \"\$@\"" | sudo tee -a "$cmd_path" > /dev/null

    # Rend le script exécutable
    sudo chmod +x "$cmd_path"
done

# Met à jour le fichier sudoers
echo "Mise à jour de sudoers..."

{
    echo ""
    for cmd in "${commands[@]}"; do
        cmd_path=$(which "${cmd}_original" 2>/dev/null)
        if [[ -n "$cmd_path" ]]; then
            echo "ALL ALL=(ALL) $cmd_path"
        fi
    done
} | sudo EDITOR='tee -a' visudo

echo "Processus terminé."
