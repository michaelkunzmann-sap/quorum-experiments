FROM ubuntu:16.04

ENV CONSTELLATION_VERSION 0.3.2
ENV CONSTELLATION_FLAVOR ubuntu1604
ENV CONSTELLATION_FILE_NAME constellation-${CONSTELLATION_VERSION}-${CONSTELLATION_FLAVOR}
ENV CONSTELLATION_RELEASE_URL https://github.com/jpmorganchase/constellation/releases/download/v${CONSTELLATION_VERSION}/${CONSTELLATION_FILE_NAME}.tar.xz

# Install system packages required
RUN apt-get update && \
    apt-get install -y \
        libdb-dev \
        libleveldb-dev \
        libsodium-dev \
        zlib1g-dev \
        libtinfo-dev \
        gettext-base \
        xz-utils \
        wget \
        curl

# Install constellation
RUN wget -q ${CONSTELLATION_RELEASE_URL} && \
    tar xf ${CONSTELLATION_FILE_NAME}.tar.xz && \
    cp ${CONSTELLATION_FILE_NAME}/constellation-node /usr/local/bin && \
    chmod 0755 /usr/local/bin/constellation-node && \
    rm -rf ${CONSTELLATION_FILE_NAME} ${CONSTELLATION_FILE_NAME}.tar.xz

COPY start.sh .

CMD [ "constellation-node" ]
