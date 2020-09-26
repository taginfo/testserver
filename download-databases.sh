#!/bin/bash
#
#  Download taginfo databases from OSMF server
#

set -e
set -x

DIR=/srv/taginfo/data

for db in master history db wiki languages projects; do
    file="taginfo-${db}.db.bz2"
    curl --silent --location --output $DIR/$file https://taginfo.openstreetmap.org/download/$file
    bunzip2 $DIR/$file
done

