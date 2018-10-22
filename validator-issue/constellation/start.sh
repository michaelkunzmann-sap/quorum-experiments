#!/bin/sh

set -e

mkdir -p /qdata/constellation

IP=$1

exec constellation-node \
  --socket=/qdata/tm.ipc \
  --storage=/qdata/constellation \
  --url=http://$IP:9000/ \
  --port=9000 \
  --tls=off 
  # --privatekeys=/k8s/secrets/constellationPrivateKeyJson --publickeys=/k8s/secrets/constellationPublicKey \
  # --passwords=/k8s/secrets/constellationPrivateKeyPassword \
  # \
  # --othernodes=http://10.31.252.157:9000/,http://10.31.245.89:9000/,http://10.31.241.176:9000/,http://10.31.255.12:9000/
  # --verbosity=1000000
