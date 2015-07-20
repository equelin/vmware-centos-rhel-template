#!/bin/bash
# Précos:
#  - Installation OS minimale
#  - VMware Tools installés

# Désactivation logs le temps de la préparation du template
echo "Desactivation logs"
/sbin/service rsyslog stop
/sbin/service auditd stop

# Désactivation SELINUX
echo "Desactivation SELINUX"
/usr/sbin/setenforce 0
sed -i -e 's!^SELINUX=.*!SELINUX=disabled!' /etc/selinux/config

# Désactivation IPTABLES
echo "Desactivation IPTABLES"
/sbin/service iptables stop
/sbin/service ip6tables stop

/sbin/chkconfig iptables off
/sbin/chkconfig ip6tables off

# Mise à jour globale de l'OS
echo "Mise à jour systeme"
yum update -y

# Installation packages WGET, NTPD et YUM-UTILS (pour package-cleanup)
echo "Installation WGET NTP YUM-UTILS"
yum install -y wget ntp yum-utils

# Démarrage service NTPD
echo "Demarrage service NTPD"
/sbin/service ntpd start

# Suppression anciens kernels
echo "Suppression anciens kernels"
/usr/bin/package-cleanup --oldkernels --count=1

#Suppression traces YUM
echo "Suppression traces YUM"
/usr/bin/yum clean all

# Force la rotation des logs en fonctions des parametres définis dans /etc/logrotate.conf
echo "Force la rotation des logs"
/usr/sbin/logrotate -f /etc/logrotate.conf

#Supprime les archives des logs
echo "Suppression des archives des logs"
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda

#Vide les logs sans avoir à redémarrer les services correspondants
echo "Vidage les logs"
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby

# Supprime les traces de la carte réseau de la VM dans udev et dans ifcfg-eth0
echo "Suppression des traces de l'ancienne carte réseau ETH0"
/bin/rm -f /etc/udev/rules.d/70*

/bin/sed -i '/^HWADDR=/d' /etc/sysconfig/network-scripts/ifcfg-eth0
/bin/sed -i '/^UUID=/d' /etc/sysconfig/network-scripts/ifcfg-eth0

# Vide les répertoires /tmp et /var/tmp
echo "Vidage répertoires /tmp et /var/tmp"
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*

# Supprime les clés SSH de la VM (elles seront regenerees au prochain démarrage)
echo "Suppresion clés SSH"
/bin/rm -f /etc/ssh/*key*

# Supprime l'historique des commandes du compte root
echo "Suppression historique commandes"
/bin/rm -f ~root/.bash_history
unset HISTFILE

# Supprime les clés SSH du compte root
echo "Suppression clé SSH du compte root"
/bin/rm -rf ~root/.ssh/

# Supprime le fichier kickstart généré par anaconda lors de l'installation de l'OS
echo "Suppression fichier kickstart généré par anaconda lors de l'installation de l'OS"
/bin/rm -f ~root/anaconda-ks.cfg

#Download motd depuis https://raw.githubusercontent.com/equelin/vmware-centos-rhel-template/master/motd
#curl https://raw.githubusercontent.com/equelin/vmware-centos-rhel-template/master/motd > /etc/motd

#Configuration sudoers
#wget -O https://raw.githubusercontent.com/equelin/vmware-centos-rhel-template/master/sudoers.sh | bash

# Arrête la VM
#/sbin/shutdown -h now
