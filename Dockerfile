# -*- mode: conf -*-
FROM postgres:9.6-alpine

MAINTAINER me@nebirhos.com

# common settings
ENV MAX_CONNECTIONS 500
ENV WAL_KEEP_SEGMENTS 256
ENV MAX_WAL_SENDERS 100

# master/slave settings
ENV REPLICATION_ROLE master
ENV REPLICATION_USER replication
ENV REPLICATION_PASSWORD ""

# slave settings
ENV POSTGRES_MASTER_SERVICE_HOST localhost
ENV POSTGRES_MASTER_SERVICE_PORT 5432

RUN apk --no-cache add \
        ca-certificates \
        libuuid \
        openssl \
        pcre \
        tzdata \
        zlib

COPY replica.conf /tmp/
COPY 10-config.sh /docker-entrypoint-initdb.d/
COPY 20-replication.sh /docker-entrypoint-initdb.d/

# Evaluate vars inside PGDATA at runtime.
# For example HOSTNAME in 'ENV PGDATA=/mnt/$HOSTNAME'
# is resolved runtime rather then during build
COPY docker-entrypoint.sh /usr/local/bin/
RUN rm /etc/localtime \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime