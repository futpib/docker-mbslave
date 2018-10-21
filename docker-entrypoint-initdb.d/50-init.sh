#!/usr/bin/env bash

# https://bitbucket.org/lalinsky/mbslave/src/af5053c947872e5ea13f2474d997f094985eb33b/README.md?at=master

set -xe

psql -c 'CREATE EXTENSION cube;'
psql -c 'CREATE EXTENSION earthdistance;'

cd /usr/src/app

sed -i "s/#token=XXX/token=${MUSICBRAINZ_TOKEN}/" mbslave.conf
sed -i '/host=/d' mbslave.conf
sed -i '/port=/d' mbslave.conf
sed -i "s/name=musicbrainz/name=postgres/" mbslave.conf
sed -i "s/user=musicbrainz/user=postgres/" mbslave.conf

echo 'CREATE SCHEMA musicbrainz;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA statistics;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA cover_art_archive;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA wikidocs;' | ./mbslave-psql.py -S
echo 'CREATE SCHEMA documentation;' | ./mbslave-psql.py -S

./mbslave-remap-schema.py < sql/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/statistics/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/caa/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/wikidocs/CreateTables.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/documentation/CreateTables.sql | ./mbslave-psql.py

./mbslave-import.py /docker-entrypoint-initdb.d/*.tar.bz2

./mbslave-remap-schema.py < sql/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/statistics/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/caa/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/wikidocs/CreatePrimaryKeys.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/documentation/CreatePrimaryKeys.sql | ./mbslave-psql.py

sed -i 's/\\set ON_ERROR_STOP.*/\\set ON_ERROR_STOP off/' sql/CreateFKConstraints.sql

./mbslave-remap-schema.py < sql/CreateFKConstraints.sql | ./mbslave-psql.py

./mbslave-remap-schema.py < sql/CreateIndexes.sql | grep -v musicbrainz_collate | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/CreateSlaveIndexes.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/statistics/CreateIndexes.sql | ./mbslave-psql.py
./mbslave-remap-schema.py < sql/caa/CreateIndexes.sql | ./mbslave-psql.py

./mbslave-remap-schema.py < sql/CreateViews.sql | ./mbslave-psql.py
