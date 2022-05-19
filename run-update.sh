#!/bin/bash
#
#  Run taginfo update cycle
#

set -euo pipefail
set -x

UPDATE_DIR=/srv/taginfo/update
DATA_DIR=/srv/taginfo/data
DOWNLOAD_DIR=/srv/taginfo/download

/srv/taginfo/taginfo/sources/update_all.sh $UPDATE_DIR

#mkdir -p $DATA_DIR/old
#mv $DATA_DIR/*.db $DATA_DIR/old/

mv $UPDATE_DIR/taginfo-*.db $UPDATE_DIR/*/taginfo-*.db $DATA_DIR/
mv $UPDATE_DIR/download/* $DOWNLOAD_DIR

