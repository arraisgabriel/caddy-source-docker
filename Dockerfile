FROM golang:latest
MAINTAINER arraisgabriel  <arraisgabriel@gmail.com>

ENV CADDYPATH github.com/mholt/caddy
ENV CADDYSRC $GOPATH/src/${CADDYPATH}
ARG caddyVersion=v0.9-beta.2
ARG caddyMainPath="${CADDYSRC}/caddy"

WORKDIR $GOPATH

RUN go get ${CADDYPATH} && \
    cd ${CADDYSRC} && \
    git checkout $caddyVersion && \
    cd $caddyMainPath && \
    #Download all caddy/caddy dependencies
    go get 
