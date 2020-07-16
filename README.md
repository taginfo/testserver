
# Setup of Taginfo Test Server

The files in this directory are used to set up a Taginfo test server. You will
need an [Hetzner cloud](https://www.hetzner.com/cloud) account and the [hcloud
command line tool](https://github.com/hetznercloud/cli).

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
    --image debian-10 \
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

* You should now be able to log into the server as root (`hcloud server
  ssh taginfo`).
* Copy the script `init.sh` to the new server and run it as `root` user:

```
IP=`hcloud server describe -o 'format={{.PublicNet.IPv4.IP}}' taginfo`
echo $IP
scp init.sh root@$IP:/tmp/
ssh -t root@$IP /tmp/init.sh
```

* If his script runs through without errors, you are done with the update of
  the server and you can now log in as the `robot` user:

```
hcloud server ssh -u robot taginfo
```

