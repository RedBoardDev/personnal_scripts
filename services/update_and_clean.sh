#!/bin/bash

dnf update -y
dnf autoremove -y
dnf clean all

if [ $? -eq 0 ]; then
    systemd-notify --ready --status="Mise à jour et nettoyage: Terminé avec succès!"
else
    systemd-notify --ready --status="Mise à jour et nettoyage: Une erreur s'est produite."
fi
