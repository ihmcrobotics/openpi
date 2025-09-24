#!/bin/bash
# Immediately exit on any errors.
set -e
# Print commands as they are run.
set -o xtrace

uv venv --python 3.11.9 $UV_PROJECT_ENVIRONMENT
GIT_LFS_SKIP_SMUDGE=1 uv sync --frozen --no-install-project --no-dev

cp -r src/openpi/models_pytorch/transformers_replace/* .venvDocker/lib/python3.11/site-packages/transformers/