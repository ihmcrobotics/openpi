#!/bin/bash
# Immediately exit on any errors.
set -e
# Print commands as they are run.
set -o xtrace

cd ../../..

# Must make sure all volumes exist or they'll get created as root
mkdir -p $HOME/.cache/uvDocker

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
    --volume $(pwd):/home/robotlab/openpi \
    --volume $HOME/.cache/uvDocker:/home/robotlab/.cache/uv \
    --volume $HOME/datasets:/home/robotlab/datasets \
    --name "${USER}_openpi_gpu123" \
    ihmcrobotics/openpi-ihmc-train:0.1 bash
#    --volume /opt/ihmc/LogData/H1/20250911_165145_H1TouchDoorHandle150/:/home/robotlab/datasets \
