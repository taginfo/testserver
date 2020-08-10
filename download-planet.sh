#!/bin/bash
#
#  Download planet file
#

set -e
set -x

DIR=/srv/taginfo/planet

curl --silent --location --output $DIR/planet.osm.pbf \
    https://planet.osm.org/pbf/planet-latest.osm.pbf

#ln -s $DIR/planet.osm.pbf $DIR/data.osm.pbf

