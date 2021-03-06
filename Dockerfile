FROM alpine
MAINTAINER Jessica Frazelle <jess@docker.com>

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go
ENV GO15VENDOREXPERIMENT 1

RUN	apk update && apk add \
	ca-certificates \
	&& rm -rf /var/cache/apk/*

COPY *.go /go/src/github.com/jfrazelle/contained/
COPY vendor /go/src/github.com/jfrazelle/contained/vendor

RUN buildDeps=' \
		go \
		git \
		gcc \
		libc-dev \
		libgcc \
	' \
	set -x \
	&& apk update \
	&& apk add $buildDeps \
	&& cd /go/src/github.com/jfrazelle/contained \
	&& go build -o /usr/bin/contained . \
	&& apk del $buildDeps \
	&& rm -rf /var/cache/apk/* \
	&& rm -rf /go \
	&& echo "Build complete."

COPY static /usr/src/contained/
WORKDIR /usr/src/contained

ENTRYPOINT [ "contained" ]
