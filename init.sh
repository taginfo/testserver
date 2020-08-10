#!/bin/bash
#
#  Initialize a taginfo server.
#
#  Must be run once as user "root" on the server when it is first created.
#

set -e
set -x

REPOSITORY=/home/robot/testserver

# -- Install Debian packages --

apt-get update -y

apt-get dist-upgrade -u -y

apt-get install -y \
    apache2 \
    cmake \
    cmake-curses-gui \
    curl \
    git \
    g++ \
    jq \
    libapache2-mod-passenger \
    libexpat1-dev \
    libgd-dev \
    libicu-dev \
    libosmium2-dev \
    libsparsehash-dev \
    libsqlite3-dev \
    libutfcpp-dev \
    m4 \
    make \
    pbzip2 \
    rsync \
    ruby \
    ruby-bundler \
    ruby-dev \
    ruby-passenger \
    sqlite3 \
    tmux \
    unzip \
    zip \
    zlib1g-dev \
    zsh

apt-get clean


# -- Stop Apache (because it isn't configured yet)

systemctl stop apache2


# -- Create robot user --

adduser --gecos "Robot User" --disabled-password robot
mkdir /home/robot/.ssh
cp /root/.ssh/authorized_keys /home/robot/.ssh
chown -R robot:robot /home/robot/.ssh
chmod 700 /home/robot/.ssh
chmod 600 /home/robot/.ssh/authorized_keys


# -- Directory setup --

DIR=/srv/taginfo
mkdir -p $DIR $DIR/data $DIR/download $DIR/planet $DIR/log $DIR/update
chown -R robot:robot $DIR


# -- Get git repositories --

su -c "git clone https://github.com/taginfo/testserver $REPOSITORY" robot
su -c "git clone https://github.com/taginfo/taginfo $DIR/taginfo" robot


# -- Set up configuration

grep -v '^ *//' $DIR/taginfo/taginfo-config-example.json | \
    jq '.logging.directory = "/srv/taginfo/log" | .paths.data_dir = "/srv/taginfo/data" | .paths.download_dir = "/srv/taginfo/download" | .sources.db.planetfile = "/srv/taginfo/planet/data.osm.pbf" | .sources.db.bindir = "/srv/taginfo/build/src" ' \
    >$DIR/taginfo-config.json

chown robot:robot $DIR/taginfo-config.json


# -- Install Ruby gems

cd /srv/taginfo/taginfo
bundle update --bundler
bundle install


# -- Apache setup --

cp $REPOSITORY/apache/taginfo.conf /etc/apache2/sites-available/000-default.conf

a2enmod cache
a2enmod cache_disk
a2enmod headers

#systemctl restart apache2.service

echo "init.sh done."

