#!/bin/bash
#
# Auteur: Erwan Quelin - http://blog.okcomputer.io
#
# Précos:
#  - Script prep_centos_rhel_7.X_part1.sh

# Désactivation log
systemctl stop rsyslog.service
/sbin/service auditd stop

# Suppression anciens kernels
/bin/package-cleanup --oldkernels --count=1 -y

#Suppression traces YUM
/usr/bin/yum clean all

# Force la rotation des logs en fonctions des parametres définis dans /etc/logrotate.conf
/usr/sbin/logrotate -f /etc/logrotate.conf

#Supprime les logs
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda

#Vide les logs sans avoir à redémarrer les services correspondants
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

# Vide les répertoires /tmp et /var/tmp
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

# Supprime les clés SSH de la VM (elles seront regenerees au prochain démarrage)
/bin/rm -f /etc/ssh/*key*

# Supprime les clés SSH du compte root
/bin/rm -rf ~root/.ssh/

# Supprime le fichier kickstart généré par anaconda lors de l'installation de l'OS
/bin/rm -f ~root/anaconda-ks.cfg

#Download motd depuis https://raw.githubusercontent.com/equelin/vmware-centos-rhel-template/master/motd
#curl https://raw.githubusercontent.com/equelin/vmware-centos-rhel-template/master/motd > /etc/motd

# Supprime l'historique des commandes du compte root
/bin/rm -f ~root/.bash_history
unset HISTFILE

# Arrête la VM
/sbin/shutdown -h now
