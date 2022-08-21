# MangosZero

Unofficial Mangos Zero docker container

contains:
```
realmd for managing realm
mangsod world of warcraft emulator
mariadb for hosting the database
nginx for mangosweb enhanced v3.04
```

up and running with 2 simple scripts
run the container like this.

```
docker run \
--name=vanilla \
-d \
-p 80:80 \
-p 8085:8085 \
-p 3724:3724 \
-p 3443:3443 \
-e PUID=0 -e PGID=0 \
-e WAN_IP_ADDRESS=127.0.0.1 \
-e DOCKER_HOST_IP=192.168.1.210 \
-e MYSQL_ROOT_PASSWORD=mangos \
-e TZ=Europe/Amsterdam \
-v /your/location/yourwowvanillaclient:/wow \
-v /your/location/config:/config \
--restart always \
solipsist01/mangoszero
```
when it's running type the following in your prompt
```
docker exec -it vanilla /bin/bash
```
Now you will be connected to the docker container.
```
/install/InstallDatabases.sh
```
This will generate the database in the mariadb database

```
/install/InstallWowfiles.sh
```
This will generate the DBC, MAPS, MMAPS, VMAPS.
They will be moved to your /config directory

browse to yourdockerip:80 and setup the mangosweb website.

If you have chosen a different password as root sql password, edit your realmd.conf and mangosd.conf in your /config/wowfiles directory

docker restart vanilla

Now everything is done.

You will have a working mangos zero up and running in a docker container.
Every file is linked and/or moved to the /config directory so settings, wowfiles, databases, will persist container destruction or upgrades.

this is an automated build, which will automatically build the latest version of mangos zero.

automatic database upgrades on startup is in the works

# Remote Admin
You need to have a GM level 3 account to access the remote admin port.
Create one the following way.

```
docker exec -it vanilla /mangos/mangosd -c /config/wowconfig/console.conf
```

This will run a mangos config on another port with console enabled.
Essentially connecting you to the mangos console.
You can do this while your production mangos is running. 

Now create your GM account (or just elevate your current account)

```
account create gmadmin Y0UB4HDSTR0NGP4SSW0RD
account set gmlevel gmadmin 3
```

You can now connect with telnet to port 3443 with your gm account for abuse of GM power ;)

# Additional scripts

```
you can run these inside the container. first run: docker exec -it vanilla bash
/install/UpdateDatabases.sh - sometimes the database is incompatible only the binaries get updated. not the database. run this script to upgrade your databases. make sure you make a backup first
/install/InstallWorld.sh - Sometimes after upgrading world, this doesn't get detected, or your world db gets corrupted. this scripts builds a new world db.
/install/UpdateWanIP.sh - Run if your wan IP has changed.
```

# Optional

After generating the wowfiles, you don't need to have linked your wow installation client anymore.

remove the docker container with:
docker rm vanilla -f

now re-run it with:
```
docker run \
--name=vanilla \
-d \
-p 80:80 \
-p 8085:8085 \
-p 3724:3724 \
-p 3443:3443 \
-e PUID=0 -e PGID=0 \
-e WAN_IP_ADDRESS=127.0.0.1 \
-e DOCKER_HOST_IP=192.168.1.210 \
-e MYSQL_ROOT_PASSWORD=mangos \
-e TZ=Europe/Amsterdam \
-v /your/location/config:/config \
--restart always \
solipsist01/mangoszero
```
Parameter breakdown:

```
docker run \
--name=vanilla \ #you can chose your own name here
-d \ #run as daemon
-p 80:80 \ #nginx web port
-p 8085:8085 \ #mangos port
-p 3724:3724 \ #realmd port
-p 3443:3443 \ #Remote Admin port (telnet)
-e PUID=0 -e PGID=0 \ #root
-e WAN_IP_ADDRESS=127.0.0.1 \ #if you want to port forward for external connection, change to your internet ip address. this address can be updated by running /install/InstallDatabases.sh
-e DOCKER_HOST_IP=192.168.1.210 \ #ip address of your docker host
-e MYSQL_ROOT_PASSWORD=mangos \ #root password of database
-e TZ=Europe/Amsterdam \ #timezone of your docker host
-v /your/location/yourwowvanillaclient:/wow \ #location to your wow vanilla client.
-v /your/location/config:/config \ #location where config files are stored
--restart always \ #automatically start when docker host restarts
solipsist01/mangoszero
```