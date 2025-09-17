#!/bin/bash
# Immediately exit on any errors.
set -e
# Print commands as they are run.
set -o xtrace

cd ../../..

docker build --tag ihmcrobotics/openpi-ihmc-dev:0.1 --file scripts/docker/ihmc-dev/Dockerfile .

xhost +local:docker

# Allow JetBrains stuff to persist state
mkdir -p $HOME/.config/JetBrainsDocker
mkdir -p $HOME/.cache/JetBrainsDocker
mkdir -p $HOME/.local/share/JetBrainsDocker

docker run \
    --tty \
    --interactive \
    --rm \
    --network host \
    --dns=1.1.1.1 \
    --user $(id -u):$(id -g) \
    --env "TERM=xterm-256color" `# Enable color in the terminal` \
    --env DISPLAY \
    --privileged \
    --gpus all \
    --shm-size=20g \
    --volume $(pwd):/openpi \
    --volume $HOME/.config/JetBrainsDocker:/.config/JetBrains:rw \
    --volume $HOME/.cache/JetBrainsDocker:/.cache/JetBrains:rw \
    --volume $HOME/.local/share/JetBrainsDocker:/.local/share/JetBrains:rw \
    --volume /opt/ihmc/LogData/H1:/opt/ihmc/LogData/H1 \
    --volume /usr/share/fonts:/usr/share/fonts \
    ihmcrobotics/openpi-ihmc-dev:0.1 pycharm
