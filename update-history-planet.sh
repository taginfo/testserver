#!/bin/bash
#
#  Update history planet file
#

DIR=/srv/taginfo/planet

pyosmium-up-to-date -v --size 5000 $DIR/history-planet.osh.pbf

