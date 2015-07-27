#!/bin/bash
#
# Auteur: Erwan Quelin - http://blog.okcomputer.io
#
# Précos:
#  - Installation OS minimale
#  - Accès internet

# Désactivation logs le temps de la préparation du template
systemctl stop rsyslog.service
/sbin/service auditd stop

# Désactivation SELINUX
setenforce 0
sed -i -e 's!^SELINUX=.*!SELINUX=disabled!' /etc/selinux/config

# Désactivation FIREWALLD
systemctl stop firewalld
systemctl disable firewalld

# Mise à jour globale de l'OS
yum update -y

# Installation packages WGET, CHRONY et YUM-UTILS (pour package-cleanup) et VMware Tools
yum install -y wget chrony open-vm-tools yum-utils

# Démarrage service Chrony
systemctl start chronyd.service

# Hack (CentOS 7) pour permettre de d'utiliser la VM en tant que template
rm -f /etc/redhat-release && touch /etc/redhat-release && echo "Red Hat Enterprise Linux Server release 7.0 (Maipo)" > /etc/redhat-release

# Redémarrage de l'OS
shutdown -r now
