#!/bin/sh
#
#  Run taginfo update cycle
#

set -e
set -x

UPDATE_DIR=/srv/taginfo/update
DATA_DIR=/srv/taginfo/data

/srv/taginfo/taginfo/sources/update-all.sh $UPDATE_DIR

#mkdir -p $DATA_DIR/old
#mv $DATA_DIR/*.db $DATA_DIR/old/

mv $UPDATE_DIR/taginfo-*.db $UPDATE_DIR/*/taginfo-*.db $DATA_DIR/

