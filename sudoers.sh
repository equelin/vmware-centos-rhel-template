#!/bin/bash

# Creation de l'utilisateur okcomputer
useradd okcomputer

# Modification du fichier /etc/sudoers pour autoriser le groupe wheel a utiliser sudo
echo "%wheel ALL=(ALL) ALL" | (EDITOR="tee -a" visudo)

# Ajout de l'utilisateur okcomputer au groupe wheel
usermod -aG wheel okcomputer

# Demande de modifier le mdp de l'utilsiateur okcomputer
passwd okcomputer
