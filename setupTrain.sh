#!/bin/bash
# Immediately exit on any errors.
set -e
# Print commands as they are run.
set -o xtrace

uv venv --python 3.11.9 $UV_PROJECT_ENVIRONMENT
GIT_LFS_SKIP_SMUDGE=1 uv sync --frozen --no-install-project --no-dev

#cp src/openpi/models_pytorch/transformers_replace/ $HOME/tmp/transformers_replace/
#$HOME/.venv/bin/python -c "import transformers; print(transformers.__file__)" | xargs dirname | xargs -I{} cp -r $HOME/tmp/transformers_replace/* {} && rm -rf /tmp/transformers_replace