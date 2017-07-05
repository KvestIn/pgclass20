#!/bin/bash
set -e

# Configure shared_preload_libraries
 gosu postgres echo "shared_preload_libraries = 'pg_stat_statements,powa,pg_qualstats,pg_stat_kcache'" >> $PGDATA/postgresql.conf

mkdir -p /srv/temp_table_spc/additional_temp_tblspc
chown -R postgres /srv/temp_table_spc/additional_temp_tblspc

# restart pg
gosu postgres pg_ctl -D "$PGDATA" -w stop -m fast
gosu postgres pg_ctl -D "$PGDATA" -w start

gosu postgres psql -f /usr/local/src/install_all.sql
gosu postgres psql -d newdb -f /usr/local/src/onec-template-8.3.10.2252.sql

# read the auto conf params
gosu postgres pg_ctl -D "$PGDATA" reload
