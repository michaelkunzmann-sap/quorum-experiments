FROM alpine:3.7

ENV QUORUM_VERSION=2.1.1
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# add scripts folder content to currect directory
COPY scripts ./

COPY start.sh .

# install quorum
RUN ./install-quorum.sh

CMD [ "geth" ]
