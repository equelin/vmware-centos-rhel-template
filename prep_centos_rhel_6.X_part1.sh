#!/bin/bash
#
# Auteur: Erwan Quelin - http://blog.okcomputer.io
#
# Précos:
#  - Installation OS minimale
#  - Accès internet

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

# Préparation installation des Open VMware Tools
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-DSA-KEY.pub
rpm --import http://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub

cat << EOF > /etc/yum.repos.d/vmware-tools.repo
[vmware-tools]
name=VMware Tools
baseurl = http://packages.vmware.com/tools/esx/latest/rhel6/\$basearch
enabled = 1
gpgcheck = 1
EOF

# Mise à jour globale de l'OS
yum update -y

# Installation packages WGET, NTPD et YUM-UTILS (pour package-cleanup)
yum install -y ntp yum-utils vmware-tools-esx-nox

# Démarrage service NTPD
/sbin/service ntpd start
/sbin/chkconfig ntpd on

# Redémarrage de l'OS
shutdown -r now
