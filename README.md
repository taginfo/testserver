
# Setup of Taginfo Test Server

The files in this directory are used to set up a Taginfo test server. You will
need an [Hetzner cloud](https://www.hetzner.com/cloud) account and the [hcloud
command line tool](https://github.com/hetznercloud/cli).

## Setting up the server

Here are the steps needed to install the master server:

* Go to the [Hetzner Cloud console](https://console.hetzner.cloud/) and log
  in.
* Add a new project `taginfo`.
* Add one or more of your ssh public keys. Name one `admin`.
* Add a new API token to the project. Put the API token somewhere safe.
* Create a hcloud context on your own machine: `hcloud context create taginfo`.
  It will ask you for the token you have just created.
* Create a new cloud server. (You can use the `--ssh-key` option multiple
  times if you have several keys to add.) On your own machine run:

```
hcloud server create \
    --name taginfo \
    --location nbg1 \
    --type cx21 \
    --image debian-11 \
    --ssh-key admin
```

or

```
hcloud server create \
    --name taginfo \
    --location nbg1 \
    --type cx21 \
    --image ubuntu-20.04 \
    --ssh-key admin
```

(Depending an what you want to do, you might need a smaller or bigger virtual
machine. For updating from a planet file you probably need a cx51 with 32 GB
RAM. If you are just running the UI, a smaller machine is fine.)

* You should now be able to log into the server as root (`hcloud server
  ssh taginfo`).
* Copy the script `init.sh` to the new server and run it as `root` user:

```
IP=$(hcloud server ip taginfo)
echo $IP
scp init.sh root@$IP:/tmp/
ssh -t root@$IP /tmp/init.sh
```

* If his script runs through without errors, you are done with the update of
  the server and you can now log in as the `robot` user:

```
hcloud server ssh -u robot taginfo
```

## Using

There are basically two different use cases for this test server:

* You want to test or work on the taginfo update mechanism
* You want to test or work on the taginfo user interface

### Test or work on the update mechanism

* Run `compile-tools.sh` once to download and compile the C++ tools that
  a taginfo update needs.
* Run `download-planet.sh` to download the current planet PBF file into the
  right place or download some other OSM file.
* Check that the config file `/srv/taginfo/taginfo-config.json` is correct.
* Run `run-update.sh` to do an update cycle at least once. For all stats to
  be updated correctly you have to run it twice.

### Test or work on the user interface

* Run `download-databases.sh` to download all databases from the main OSMF
  server to get you set up quickly.

