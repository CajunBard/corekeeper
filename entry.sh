#!/bin/bash

if [ $branch = experimental ] ; then
        APPID="1963720 -beta experimental"
else
        APPID="1963720"
fi

mkdir -p /config/Pugstorm
mkdir -p /home/steam/.config/unity3d
ln -s /config/Pugstorm /home/steam/.config/unity3d/Pugstorm

# When the Dedicated Server was released the save/config files changed locations
# Performing a one time move to preserve data
if [ -d "/config/Pugstorm/Core Keeper/experimental" ] ; then
        tar -cvf /config/experimental-backup-$(date '+%y-%m-%d-%H-%M').tar /config/Pugstorm/Core\ Keeper/experimental/
        mv /config/Pugstorm/Core\ Keeper/experimental/* /config/Pugstorm/Core\ Keeper/
        rm -rf /config/Pugstorm/Core\ Keeper/experimental
fi

/home/steam/steamcmd.sh +force_install_dir /config +login anonymous +app_update $APPID validate +quit

# the game looks for steamclient.so in the sdk64 folder
# but this doesn't exist by default with steamcmd
ln -s /home/steam/linux64 /home/steam/.steam/sdk64

cd /config

# if the container doesn't exit cleanly
# then the display is locked and we need to clear this file
lockfile=/tmp/.X99-lock
if [ -f $lockfile ] ; then
        echo "Display :99 is locked, removing $lockfile"
        rm /tmp/.X99-lock -f
fi

set -m

Xvfb :99 -screen 0 1x1x24 -nolisten tcp &
xvfbpid=$!

rm -f GameID.txt

chmod +x ./CoreKeeperServer
DISPLAY=:99 /config/CoreKeeperServer -batchmode -logfile /dev/stdout "$@" &
ckpid=$!

echo "Started server process with pid $ckpid"

while [ ! -f GameID.txt ]; do
        sleep 0.1
done

echo "Game ID: $(cat GameID.txt)"

wait $ckpid