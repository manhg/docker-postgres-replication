#!/bin/bash
set -e

echo [*] configuring $REPLICATION_ROLE instance

# We set master replication-related parameters for both slave and master,
# so that the slave might work as a primary after failover.
cat /tmp/replica.conf >> "$PGDATA/postgresql.conf"

echo "host replication $REPLICATION_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
