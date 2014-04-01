#!/bin/bash

configServerPort1=$1
configServerPort2=$2
configServerPort3=$3

#ipaddress=`ifconfig eth0 | perl -n -e 'if (m/inet addr:([\d\.]+)/g) { print $1 }'`
configHost1=config-1.mongo-server.com
configHost2=config-2.mongo-server.com
configHost3=config-3.mongo-server.com

configdb=${configHost1}:${configServerPort1},${configHost2}:${configServerPort2},${configHost3}:${configServerPort3}

basePath=/media
logPathDir=$basePath/log/mongos

mkdir -p $logPathDir

logPath=$logPathDir/mongos.log

mongos --logpath $logPath --configdb $configdb --fork
