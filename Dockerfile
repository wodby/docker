ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

RUN set -xe; \
    \
    apk add --update --no-cache docker; \
    \
    rm -rf /var/cache/apk/*
