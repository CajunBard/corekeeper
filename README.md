# Introduction

This image uses SteamCMD to download the server binaries to a persistent volume so that it doesn't have to be downloaded in full each time. 

With release v0.3.12 of the game, Pugstorm also released the Dedicated Server under its own AppID on steam (yay!), which allows us use anonymous logon for SteamCMD. If you used a previous version of this image, you can remove the STEAMUSER and STEAMPWD variables from your docker run command.

# Volume

The game's persistent data has been symlinked to the path `/config` within the container. The world save is stored in `/config/Pugstorm/Core Keeper/DedicatedServer/worlds`. If you wish to persist this storage, create a volume on the host. An example of that is provided below.

Release v.0.3.13.1 of the docker image will migrate an existing world from the previous experimental build if it is found. It will also make a backup in the root of the /config volume, just in case. The previous location was `/config/Pugstorm/Core Keeper/experimental/DedicatedServer/worlds`.

# Variables

## branch

This variable allows you to specify the beta branch of the game and currently supports the `experimental` tag.

**Example Run Usage**

```
docker run -d --name=corekeeper -p 27015:27016/udp cajunbard/corekeeper:latest
```

**Example with Volume**

```
# Create the volume

docker volume create corekeeper

# Run using the volume

docker run -d --name=corekeeper  -p 27015:27016/udp -v corekeeper:/config:rw cajunbard/corekeeper:latest
```

**Example with Volume on Experimental**

```
# Create the volume

docker volume create corekeeper

# Run using the volume

docker run -d --name=corekeeper  -p 27015:27016/udp -v corekeeper:/config:rw -e branch=experimental cajunbard/corekeeper:latest
```

## Game ID

Since Core Keeper uses a "Game ID" that players will need to use to join your server, you will need to make note of this after the container starts. The Game ID can be obtained by viewing the container's logs. Note that this Game ID can change anytime the server restarts. It can also be changed by an Admin within the game.

**Example**

```
docker logs corekeeper -n 1
Game ID: 8pldcwQSjMleGs8DRK9MbZiNfCKj
```

The first player to connect to the server will be designated as the Admin, so it's very important that you do not give the Game ID out until you confirm that the intended player is an administrator. Administrators have the ability to create a new Game ID from within the game, as well.