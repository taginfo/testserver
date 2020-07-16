#!/bin/bash
#
#  Initialize a taginfo server.
#
#  Must be run once as user "root" on the server when it is first created.
#

set -e
set -x

REPOSITORY=/home/robot/testserver
BIN=/usr/local/bin

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
mkdir -p $DIR $DIR/data $DIR/download $DIR/planet $DIR/var/log $DIR/var/sources
chown -R robot:robot $DIR


# -- Links to tools --

# These will only be available if compile-tools.sh is run, but then they
# will immediately be in the PATH.
for i in similarity stats unicode; do
    ln -s /usr/local/bin/taginfo-$i $DIR/build/src/taginfo-$i
end


# -- Get git repositories --

su -c "git clone https://github.com/taginfo/testserver $REPOSITORY" robot
su -c "git clone https://github.com/taginfo/taginfo $DIR/taginfo" robot


# -- Set up configuration

grep -v '^ *//' $DIR/taginfo/taginfo-config-example.json | \
    jq '.logging.directory = "/srv/taginfo/var/log" | .paths.data_dir = "/srv/taginfo/data" | .paths.download_dir = "/srv/taginfo/download" | .sources.db.planetfile = "/srv/taginfo/planet/data.osm.pbf"' \
    >$DIR/taginfo-config.json

chown robot:robot $DIR/taginfo-config.json


# -- Install Ruby gems

bundle update --bundler
(cd /srv/taginfo/taginfo; bundle install)


# -- Apache setup --

cp $REPOSITORY/apache/taginfo.conf /etc/apache2/sites-available/000-default.conf

a2enmod cache
a2enmod cache_disk
a2enmod headers
a2enmod passenger

#systemctl restart apache2.service

echo "init.sh done."

