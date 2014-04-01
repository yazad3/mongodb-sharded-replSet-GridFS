mongo shard1_repl1.mongo-server.com:3001/admin --eval "db.shutdownServer({force: true});"
mongo shard1_repl2.mongo-server.com:3002/admin --eval "db.shutdownServer({force: true})"
mongo shard1_repl3.mongo-server.com:3003/admin --eval "db.shutdownServer({force: true})"

mongo shard2_repl1.mongo-server.com:6001/admin --eval "db.shutdownServer({force: true})"
mongo shard2_repl2.mongo-server.com:6002/admin --eval "db.shutdownServer({force: true})"
mongo shard2_repl3.mongo-server.com:6003/admin --eval "db.shutdownServer({force: true})"

#NOOP If service not started for Shard 3.
mongo shard3_repl1.mongo-server.com:10001/admin --eval "db.shutdownServer({force: true});"
mongo shard3_repl2.mongo-server.com:10002/admin --eval "db.shutdownServer({force: true})"
mongo shard3_repl3.mongo-server.com:10003/admin --eval "db.shutdownServer({force: true})"

mongo config-1.mongo-server.com:8001/admin --eval "db.shutdownServer({force: true})"
mongo config-2.mongo-server.com:8002/admin --eval "db.shutdownServer({force: true})"
mongo config-3.mongo-server.com:8003/admin --eval "db.shutdownServer({force: true})"

sleep 5

mongo mongos.mongo-server.com:27017/admin --eval "db.shutdownServer({force: true})"
