# Introduction

Core Keeper's dedicated server is currently provided in the experimental branch of the main game, so you will need to have a Steam account that is entitled to it. This image uses SteamCMD to download the game binaries to a persistent volume so that it doesn't have to be downloaded in full each time. It is recommended that you use a dedicated Steam account for this purpose that does not have Steam Guard enabled. Having Steam Guard enabled will cause an authentication error during startup.

This is an _experimental_ release, which will be refined and improved over time.

# Volume

The game's persistent data has been symlinked to the path `/config` within the container. The world save is stored in `/config/Pugstorm/Core Keeper/experimental/DedicatedServer/worlds`. If you wish to persist this storage, create a volume on the host. 

# Variables

## STEAMUSER

This variable is your Steam Username, required to authenticate to Steam using SteamCMD.

## STEAMPWD

This variable is your Steam Password, required to authenticate to Steam using SteamCMD.

**Example Run Usage**

`docker run -d --name=corekeeper -e STEAMUSER=<your steam username> -e STEAMPWD=<your steam password> -p 27015:27016/udp cajunbard/corekeeper:latest`

## Game ID

Since Core Keeper uses a "Game ID" that players will need to use to join your server, you will need to make note of this after the container starts. The Game ID can be obtained by viewing the container's logs. Note that this Game ID can change anytime the server restarts. It can also be changed by an Admin within the game.

**Example**

```
docker logs corekeeper -n 1
Game ID: 8pldcwQSjMleGs8DRK9MbZiNfCKj
```

The first player to connect to the server will be designated as the Admin, so it's very important that you do not give the Game ID out until you confirm that the intended player is an administrator. Administrators have the ability to create a new Game ID from within the game, as well.