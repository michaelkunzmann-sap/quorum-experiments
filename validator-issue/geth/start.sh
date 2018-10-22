#!/bin/sh

set -e

mkdir -p /qdata/dd


rm -rf /qdata/dd/geth || true

geth --datadir /qdata/dd init /shared/genesis.json

cp /shared/static-nodes.json /qdata/dd/
cp /shared/permissioned-nodes.json /qdata/dd/

exec geth \
  --datadir /qdata/dd \
  --port 30303 \
  --mine --minerthreads 1 \
  --istanbul.requesttimeout 10000 -istanbul.blockperiod 1 \
  --emitcheckpoints \
  --rpc --rpcport 8545 --rpcaddr 0.0.0.0 --rpcapi eth,web3,db,net,txpool,personal,quorum,istanbul \
  --networkid 1226637884 \
  --permissioned \
  --nodiscover \
  --verbosity 3
