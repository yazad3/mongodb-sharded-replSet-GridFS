#!/bin/bash

read -p "Are you sure you want to delete? " yn;

case $yn in
  [Yy]* ) rm -fr /media/shard1_repl1/data /media/shard1_repl2/data /media/shard1_repl3/data /media/shard2_repl1/data /media/shard2_repl2/data /media/shard2_repl3/data /media/log /media/config-1/data /media/config-2/data /media/config-3/data; exit;;
  [Nn]* ) exit;;
  * ) echo "Please answer yes or no.";;
esac
