#!/bin/bash
# Immediately exit on any errors.
set -e
# Print commands as they are run.
set -o xtrace

cd ../../..

mkdir -p $HOME/.cache/uv

docker build --tag ihmcrobotics/openpi-ihmc-train:0.1 \
             --build-arg HOST_UID=$(id -u) \
             --build-arg HOST_GID=$(id -g) \
             --file scripts/docker/ihmc-train/Dockerfile .

docker run \
    --tty \
    --interactive \
    --rm \
    --network host \
    --dns=1.1.1.1 \
    --env "TERM=xterm-256color" `# Enable color in the terminal` \
    --privileged \
    --gpus all \
    --shm-size=20g \
    --volume $HOME/.cache/uv:/home/robotlab/.cache/uv \
    --volume $(pwd):/home/robotlab/openpi \
    --volume $HOME/datasets:/home/robotlab/datasets \
    ihmcrobotics/openpi-ihmc-train:0.1 bash
