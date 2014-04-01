#!/bin/bash

#
#mongos
#  shard1
#    repl1-node1
#    repl1-node2
#    repl1-node3
#  shard2
#    repl2-node1
#    repl2-node2
#    repl2-node3
#  confgdb1
#  confgdb2
#  confgdb3
#

#if init is set to TRUE the execute additional steps besides server startup.
init=$1

if [[ -z ${init} ]]; then
  init=FALSE;
  
  echo "init: ${init}; for initial setup run the command with one parameter TRUE."
  echo "Example:"
  echo "${0} TRUE.";
fi;

#Setup
shard=shard1
repl1=$shard\_repl1
repl2=$shard\_repl2
repl3=$shard\_repl3

port1=3001
port2=3002
port3=3003

#Setup Shard - Shard1
./_createMongoDBShardedReplSet.sh $shard $repl1 ${port1}
./_createMongoDBShardedReplSet.sh $shard $repl2 ${port2}
./_createMongoDBShardedReplSet.sh $shard $repl3 ${port3}


if [ ${init} = 'TRUE' ]; then

  sleep 20
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.initiate();"
  sleep 20
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.add('"${repl2}".mongo-server.com:"${port2}"');"
  sleep 15
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.add('"${repl3}".mongo-server.com:"${port3}"');"
  sleep 15
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.status()"
fi;

echo

#Setup Shard - Shard2
sleep 15

shard=shard2
repl1=$shard\_repl1
repl2=$shard\_repl2
repl3=$shard\_repl3

port1=6001
port2=6002
port3=6003

./_createMongoDBShardedReplSet.sh $shard $repl1 ${port1}
./_createMongoDBShardedReplSet.sh $shard $repl2 ${port2}
./_createMongoDBShardedReplSet.sh $shard $repl3 ${port3}

if [ ${init} = 'TRUE' ]; then

  sleep 30
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.initiate();"
  sleep 20
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.add('"${repl2}".mongo-server.com:"${port2}"');"
  sleep 25
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.add('"${repl3}".mongo-server.com:"${port3}"');"
  sleep 25
  mongo ${repl1}.mongo-server.com:${port1}/admin --eval "rs.status()"

fi;
echo

#Setup Config Servers
sleep 20

config1=config-1
config2=config-2
config3=config-3

configServerPort1=8001
configServerPort2=8002
configServerPort3=8003

./_createMongoDBConfigSvr.sh ${config1} $configServerPort1
./_createMongoDBConfigSvr.sh ${config2} $configServerPort2
./_createMongoDBConfigSvr.sh ${config3} $configServerPort3

echo
sleep 25

./_configMongoDBShard.sh $configServerPort1 $configServerPort2 $configServerPort3

if [ ${init} = 'TRUE' ]; then

  sleep 25

  mongo mongos.mongo-server.com:27017/admin --eval 'sh.addShard("shard1/shard1_repl1.mongo-server.com:3001")'
  sleep 15
  mongo mongos.mongo-server.com:27017/admin --eval 'sh.addShard("shard2/shard2_repl1.mongo-server.com:6001")'
  sleep 15
  mongo mongos.mongo-server.com:27017/admin --eval 'sh.enableSharding("test")'
  sleep 15
  mongo mongos.mongo-server.com:27017/admin --eval 'sh.shardCollection("test.fs.chunks", {files_id: 1, n: 1})'
  #sleep 5
  #mongo mongos.mongo-server.com:27017/test --eval 'db.fs.chunk.ensureIndex({files_id: 1, n: 1})'
fi;