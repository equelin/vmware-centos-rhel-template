#!/bin/sh

# Précos:
#  - Installation OS minimale
#  - VMware Tools installés

# Désactivation logs le temps de la préparation du template
/sbin/service rsyslog stop
/sbin/service auditd stop

# Désactivation SELINUX
/usr/sbin/setenforce 0
sed -i -e 's!^SELINUX=.*!SELINUX=disabled!' /etc/selinux/config

# Désactivation IPTABLES
/sbin/service iptables stop
/sbin/service ip6tables stop

/sbin/chkconfig iptables off
/sbin/chkconfig ip6tables off

# Mise à jour globale de l'OS
yum update -y

# Installation packages WGET, NTPD et YUM-UTILS (pour package-cleanup)
yum install -y wget ntp yum-utils

# Démarrage service Chrony
/sbin/service ntpd start

# Suppression anciens kernels
/usr/bin/package-cleanup --oldkernels --count=1

#Suppression traces YUM
/usr/bin/yum clean all

# Force la rotation des logs en fonctions des parametres définis dans /etc/logrotate.conf
/usr/sbin/logrotate -f /etc/logrotate.conf

#Supprime les archives des logs
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda

#Vide les logs sans avoir à redémarrer les services correspondants
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

# Supprime les traces de la carte réseau de la VM dans udev et dans ifcfg-eth0
/bin/rm -f /etc/udev/rules.d/70*

/bin/sed -i '/^HWADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eth0
/bin/sed -i '/^UUID=/d' /etc/sysconfig/network-scripts/ifcfg-eth0

# Vide les répertoires /tmp et /var/tmp
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

# Supprime les clés SSH de la VM (elles seront regenerees au prochain démarrage)
/bin/rm -f /etc/ssh/*key*

# Supprime l'historique des commandes du compte root
/bin/rm -f ~root/.bash_history
unset HISTFILE

# Supprime les clés SSH du compte root
/bin/rm -rf ~root/.ssh/

# Supprime le fichier kickstart généré par anaconda lors de l'installation de l'OS
/bin/rm -f ~root/anaconda-ks.cfg

# Arrête la VM
#/sbin/shutdown -h now
