# Alpine :: Host Command
Run a Host Shell based on Alpine Linux. Small, lightweight and fast 🏔️

This container will expose your hosts shell via web, do use at your own risk.

It was created for the reddit use [BiltuDas_1](https://www.reddit.com/user/BiltuDas_1)

## Run
```shell
docker run --name host-command \
  --network=host-command \
  -e HOST_IP=172.28.5.254 \
  -v .../id_ed25519:/root/.ssh/id_ed25519:ro \
  -d 11notes/host-command:[tag]
```

## Defaults
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | root | user |
| `uid` | 0 | user id |
| `gid` | 0 | group id |
| `home` | /root | home directory of user root |

## Environment
| Parameter | Value | Default |
| --- | --- | --- |
| `HOST_IP` | IP of the host running docker | 60 |

## Docker Network Example
```shell
docker network create \
  --driver=bridge \
  --subnet=172.28.0.0/16 \
  --ip-range=172.28.5.0/24 \
  --gateway=172.28.5.254 \
  host-command
```

You must create a private key on your host and enable key authentication via SSH. The docker container will connect via SSH and issue the commands.


## Parent
* [11notes/node:stable](https://github.com/11notes/docker-node)

## Built with
* [nodejs](https://nodejs.org/en)
* [Alpine Linux](https://alpinelinux.org)

## Tips
* Do not run this container in production! Make a dedicated user with a gid/id and only allow access to the shell commands you need (like reboot, poweroff)
* Do not run this container as root but as a dedicated user on your host