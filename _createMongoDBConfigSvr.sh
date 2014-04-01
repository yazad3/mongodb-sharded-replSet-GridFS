#!/bin/bash

configSvrName=$1
port=$2

basePath=/media
dbPathDir=$basePath/$configSvrName/data/
logPathDir=$basePath/log/$configSvrName

mkdir -p $dbPathDir $logPathDir

logPath=$logPathDir/$configSvrName.log

bind_ip=${configSvrName}.mongo-server.com

mongod --logpath ${logPath} --dbpath ${dbPathDir} --bind_ip ${bind_ip} --port ${port} --configsvr --fork
