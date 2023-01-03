# test builder
FROM alpine:latest

COPY . /src

WORKDIR /src

RUN apk update
RUN apk add build-base linux-headers make cmake git bash \
        zlib-dev openssl-libs-static openssl-dev openssl
RUN git config --global --add safe.directory /src/src/thirdparty/libwebsockets

RUN make -j
