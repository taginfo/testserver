#!/bin/bash
#
#  Update planet file
#

DIR=/srv/taginfo/planet

pyosmium-up-to-date -v --size 5000 $DIR/planet.osm.pbf

