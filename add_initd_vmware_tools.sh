#!/bin/bash

cp /etc/vmware-tools/services.sh /etc/init.d/vmware-tools

perl -0777 -i.original -pe 's/##VMWARE_INIT_INFO##/# chkconfig: 2345 90 60\n# description: Manages the services needed to run VMware Tools /igs' /etc/init.d/vmware-tools

chkconfig --add vmware-tools
chkconfig vmware-tools on

services vmware-tools restart
