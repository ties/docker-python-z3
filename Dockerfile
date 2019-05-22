FROM python:alpine
# Take the most recent Alpine Python tag as the base of this image.
# shared tags are:
# 3.7.1-alpine3.8, 3.7-alpine3.8, 3-alpine3.8, alpine3.8, 3.7.1-alpine, 3.7-alpine, 3-alpine, alpine

LABEL maintainer="Ties de Kock"
LABEL homepage="https://github.com/ties/docker-python-z3"

# Build Z3 based on <https://github.com/eelkevdbos/z3-http/blob/master/Dockerfile>
ARG Z3_VERSION="4.8.4"
ARG NPROC="8"
ENV Z3_ARGS="-smt2,-in"

RUN apk update \
 && apk add --virtual .devdeps linux-headers musl-dev gcc libxml2-dev libxslt-dev openssh libffi-dev \
 && apk add --no-cache --virtual .z3deps binutils build-base ca-certificates python wget make \
 && apk add bash libxml2 libxslt libffi git libstdc++ libgcc libgomp \
 && wget https://github.com/Z3Prover/z3/archive/z3-${Z3_VERSION}.tar.gz \
 && tar -xvzf z3-${Z3_VERSION}.tar.gz \
 && cd z3-z3-${Z3_VERSION} && python scripts/mk_make.py --python \
 && cd build && make -j ${NPROC} && make install && cd ../.. \
 && rm -rf z3-z3-${Z3_VERSION} \
 && rm -rf z3-${Z3_VERSION}.tar.gz \
 && pip install -U pip \
 && pip install wheel \
 && apk del .z3deps \
 && apk del .devdeps \
 && rm -rf /var/cache/apk/*

CMD ["/usr/local/bin/python"]
