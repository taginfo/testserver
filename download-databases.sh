#!/bin/bash
#
#  Download taginfo databases from OSMF server
#

set -e
set -x

DIR=/srv/taginfo/data

for db in master history db wiki languages projects search; do
    file="taginfo-${db}.db.bz2"
    curl --silent --output $DIR/$file https://taginfo.openstreetmap.org/download/$file
    bunzip2 $DIR/$file
done
