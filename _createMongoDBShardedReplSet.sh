#!/bin/bash

shard=$1
replSet=$2
port=$3

basePath=/media
dbPathDir=$basePath/$replSet/data/
logPathDir=$basePath/log/$shard/$replSet

#Create directories for DB and Log
mkdir -p $dbPathDir $logPathDir

logPath=$logPathDir/$replSet.log

bind_ip=$replSet.mongo-server.com

mongod --replSet $shard --logpath $logPath --dbpath $dbPathDir --bind_ip $bind_ip --port $port --shardsvr --fork
