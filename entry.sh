#!/bin/bash

if [ $STEAMUSER = default ]; then
        echo Please specify your steam username when running the docker container.
        echo For example \"docker run -d -e STEAMUSER=username -e STEAMPWD=password cajunbard/corekeeper\"
        exit 1
fi

if [ $STEAMPWD = default ]; then
        echo Please specify your steam password when running the docker container.
        echo For example \"docker run -d -e STEAMUSER=username -e STEAMPWD=password cajunbard/corekeeper\"
        exit 1
fi

mkdir -p /config/Pugstorm
mkdir -p /home/steam/.config/unity3d
ln -s /config/Pugstorm /home/steam/.config/unity3d/Pugstorm

/home/steam/steamcmd.sh +force_install_dir /config +login $STEAMUSER $STEAMPWD "+app_update 1621690 -beta experimental" validate +quit

# the game looks for steamclient.so in the sdk64 folder
# but this doesn't exist by default with steamcmd
ln -s /home/steam/linux64 /home/steam/.steam/sdk64

cd /config/Server

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
DISPLAY=:99 /config/Server/CoreKeeperServer -batchmode -logfile /dev/stdout "$@" &
ckpid=$!

echo "Started server process with pid $ckpid"

while [ ! -f GameID.txt ]; do
        sleep 0.1
done

echo "Game ID: $(cat GameID.txt)"

#keep the container alive
tail -f /dev/null