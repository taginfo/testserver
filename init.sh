#!/bin/bash
#
#  Initialize a taginfo server.
#
#  Must be run once as user "root" on the server when it is first created.
#

set -e
set -x

DIR=/srv/taginfo
REPOSITORY=/home/robot/testserver

# -- Install Debian packages --

apt-get update -y

apt-get dist-upgrade -u -y

# Packages needed for taginfo-tools
apt-get install -y \
    cmake \
    cmake-curses-gui \
    g++ \
    libbz2-dev \
    libexpat1-dev \
    libgd-dev \
    libicu-dev \
    libosmium2-dev \
    libprotozero-dev \
    libsqlite3-dev \
    make \
    zlib1g-dev

# Packages needed for taginfo
apt-get install -y \
    curl \
    jq \
    pbzip2 \
    ruby \
    ruby-dev \
    sqlite3 \
    unzip \
    zip

RUBY_VERSION=`ruby -e "puts RUBY_VERSION.split('.')[0..1].join('.')"`

# Packages needed for running in uWSGI application server
apt-get install -y \
    uwsgi-core \
    uwsgi-plugin-rack-ruby$RUBY_VERSION

# Packages needed for running under Apache
apt-get install -y \
    apache2 \
    libapache2-mod-passenger \
    ruby-passenger

# Other useful packages
apt-get install -y \
    git \
    osmium-tool \
    pyosmium \
    rsync \
    tmux \
    zsh

apt-get clean


# -- Stop Apache (because it isn't configured yet)

systemctl stop apache2


# -- Create robot user --

grep --quiet robot /etc/passwd || \
    adduser --gecos "Robot User" --disabled-password robot

mkdir -p /home/robot/.ssh
cp /root/.ssh/authorized_keys /home/robot/.ssh
chown -R robot:robot /home/robot/.ssh
chmod 700 /home/robot/.ssh
chmod 600 /home/robot/.ssh/authorized_keys


# -- Directory setup --

mkdir -p $DIR $DIR/data $DIR/download $DIR/planet $DIR/log $DIR/update
chown -R robot:robot $DIR


# -- Get git repositories --

rm -fr $REPOSITORY
su -c "git clone https://github.com/taginfo/testserver $REPOSITORY" robot

rm -fr $DIR/taginfo
su -c "git clone https://github.com/taginfo/taginfo $DIR/taginfo" robot


# -- Set up configuration

grep -v '^ *//' $DIR/taginfo/taginfo-config-example.json | \
    jq '.logging.directory                   = "/srv/taginfo/log"' | \
    jq '.paths.data_dir                      = "/srv/taginfo/data"' | \
    jq '.paths.download_dir                  = "/srv/taginfo/download"' | \
    jq '.paths.bin_dir                       = "/srv/taginfo/build/src"' | \
    jq '.sources.db.planetfile               = "/srv/taginfo/planet/data.osm.pbf"' | \
    jq '.sources.chronology.osm_history_file = "/srv/taginfo/planet/history-data.osh.pbf"' | \
    jq '.sources.db.bindir                   = "/srv/taginfo/build/src"' \
    >$DIR/taginfo-config.json

chown robot:robot $DIR/taginfo-config.json


# -- Install Ruby gems

cd /srv/taginfo/taginfo
gem install bundler
bundle install


# -- Apache setup --

cp $REPOSITORY/apache/taginfo.conf /etc/apache2/sites-available/000-default.conf

a2enmod cache
a2enmod cache_disk
a2enmod headers

#systemctl restart apache2.service

echo "init.sh done."

