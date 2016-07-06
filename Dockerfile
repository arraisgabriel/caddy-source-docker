FROM golang:latest

ENV CADDYPATH github.com/mholt/caddy
ENV CADDYSRC $GOPATH/src/${CADDYPATH}
ARG caddyVersion=v0.9-beta.2
ARG caddyMainPath="${CADDYSRC}/caddy/caddymain"

#Strings used to import caddy plugins
ARG caddyImportAnchor="\"github.com\/mholt\/caddy\""
ARG certsAutomationModuleSub="\"github.com\/vtex\/caddy-certs-automation\""
ARG certsAutomationModule="github.com/vtex/caddy-certs-automation"

WORKDIR $GOPATH

RUN apt-get update && apt-get install -y --no-install-recommends sed

# https://github.com/golang/go/issues/9344#issuecomment-69944514
RUN go get ${CADDYPATH} && \
    cd ${CADDYSRC} && \
    git checkout $caddyVersion && \
    cd $caddyMainPath && \
    go get 
        
#TODO: put the lines below in vtex/hodor image
#See https://github.com/caddyserver/caddyext/issues/7 to understand the sed below
RUN sed -i "s/$caddyImportAnchor/$caddyImportAnchor\n    _ $certsAutomationModuleSub/g" $caddyMainPath/run.go && \
    go get $certsAutomationModule

RUN go build -o bin/caddy ${CADDYPATH}/caddy 
RUN chmod +x bin/caddy 

