#!/bin/sh

set -e

# packages we can throw away later
tmp_packages="make musl-dev linux-headers g++ gcc git go wget unzip"

# packages we need during runtime
persistent_packages="bash gnupg1 jq"

# Install dependencies
echo "---> Installing packages"
apk update 
apk add $tmp_packages $persistent_packages

# Configure Go
mkdir -p ${GOPATH}/src ${GOPATH}/bin

# Install Quorum
echo "---> Installing Quorum..."
wget -q https://github.com/jpmorganchase/quorum/archive/v${QUORUM_VERSION}.zip && \
unzip -q v${QUORUM_VERSION}.zip && \
(cd quorum-${QUORUM_VERSION} && make all && \
  cp build/bin/geth /usr/local/bin && \
  cp build/bin/bootnode /usr/local/bin)


# Clean up
echo "---> Cleaning up...."
rm -rf quorum-${QUORUM_VERSION} v${QUORUM_VERSION}.zip || echo "Unable to clean up files"
apk del $tmp_packages || echo "unable to delete packages"
