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
    mesa-utils \
    libxrender1 \
    libxext6 \
    libsm6 \
    libxtst6 \
    libxi6 \
    > /dev/null \
 && rm -rf /var/lib/apt/lists/*

# PyCharm (https://www.jetbrains.com/pycharm/download/#section=linux)
RUN mkdir -p Downloads \
 && cd Downloads \
 && curl -sL https://download.jetbrains.com/python/pycharm-community-2025.2.0.1.tar.gz -o pycharm.tar.gz \
 && tar -xzf pycharm.tar.gz \
 && mv pycharm-community-2025.2.0.1/ /opt/pycharm \
 && ln -s /opt/pycharm/bin/pycharm.sh /usr/local/bin/pycharm \
 && cd .. \
 && rm -rf Downloads

COPY . openpi
WORKDIR /openpi

ENV UV_LINK_MODE=copy
ENV UV_PROJECT_ENVIRONMENT=/.venv

#RUN uv venv --python 3.11.9 $UV_PROJECT_ENVIRONMENT
# RUN #--mount=type=cache,target=/root/.cache/uv \
#    --mount=type=bind,source=uv.lock,target=uv.lock \
#    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
#    --mount=type=bind,source=packages/openpi-client/pyproject.toml,target=packages/openpi-client/pyproject.toml \
#    --mount=type=bind,source=packages/openpi-client/src,target=packages/openpi-client/src \
RUN GIT_LFS_SKIP_SMUDGE=1 uv sync && uv pip install -e .

# Appears to patch transformers on the system
COPY src/openpi/models_pytorch/transformers_replace/ /tmp/transformers_replace/
RUN /.venv/bin/python -c "import transformers; print(transformers.__file__)" | xargs dirname | xargs -I{} cp -r /tmp/transformers_replace/* {} && rm -rf /tmp/transformers_replace
