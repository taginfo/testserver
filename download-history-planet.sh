#!/bin/bash
#
#  Download history planet file
#

set -e
set -x

DIR=/srv/taginfo/planet

curl --silent --location --output $DIR/history-planet.osh.pbf \
    https://planet.osm.org/pbf/full-history/history-latest.osm.pbf

#ln -s $DIR/history-planet.osh.pbf $DIR/history-data.osh.pbf

