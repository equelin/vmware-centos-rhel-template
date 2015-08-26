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

# Installation VMware Tools (Hack CentOS 7 pour permettre le creation de templates)
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub

cat << EOF > /etc/yum.repos.d/vmware-tools.repo
[vmware-tools]
name=VMware Tools
baseurl = http://packages.vmware.com/packages/rhel7/\$basearch
enabled = 1
gpgcheck = 1
EOF

rm -f /etc/redhat-release && touch /etc/redhat-release && echo "Red Hat Enterprise Linux Server release 7.0 (Maipo)" > /etc/redhat-release

# Mise à jour globale de l'OS
yum update -y

# Installation packages WGET, CHRONY et YUM-UTILS (pour package-cleanup) et VMware Tools
yum install -y wget chrony perl open-vm-tools open-vm-tools-deploypkg yum-utils

# Démarrage service Chrony
systemctl start chronyd.service

# Redémarrage de l'OS
shutdown -r now
