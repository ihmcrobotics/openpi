FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04@sha256:2d913b09e6be8387e1a10976933642c73c840c0b735f0bf3c28d97fc9bc422e0
COPY --from=ghcr.io/astral-sh/uv:0.5.1 /uv /uvx /bin/

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get --quiet 2 --yes update  \
 && apt-get --quiet 2 --yes install \
    nano \
    git \
    git-lfs \
    linux-headers-generic \
    build-essential \
    clang \
    wget \
    curl \
    unzip \
    apt-transport-https \
    iputils-ping \
    ca-certificates \
    curl \
    software-properties-common \
    sudo \
    iproute2 \
    > /dev/null \
 && rm -rf /var/lib/apt/lists/*

ARG HOST_UID
ARG HOST_GID

RUN addgroup --gid "${HOST_GID}" robotlab  \
 && adduser --uid "${HOST_UID}" --ingroup robotlab --shell /bin/bash robotlab \
 && usermod --append --groups root robotlab

USER robotlab
ENV HOME=/home/robotlab
WORKDIR ${HOME}

COPY --chown=robotlab:robotlab . openpi
WORKDIR ${HOME}/openpi

ENV UV_LINK_MODE=copy

# Not sure if needed, the .cache/uv was showing up as root, causing problems
RUN mkdir -p ${HOME}/.cache/uv
