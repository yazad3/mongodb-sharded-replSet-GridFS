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
shard=shard3
repl1=$shard\_repl1
repl2=$shard\_repl2
repl3=$shard\_repl3

port1=10001
port2=10002
port3=10003

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

if [ ${init} = 'TRUE' ]; then

  sleep 25

  mongo mongos.mongo-server.com:27017/admin --eval 'sh.addShard("shard3/shard3_repl1.mongo-server.com:10001")'

fi;