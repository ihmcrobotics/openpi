# Notes for IHMC workflow

See the below notes for running training and inference.

## Dataset creation

Datasets are generated from IHMC logs using a robot specific app such as `H1RDXSCS2LogVisualizer`.
The result will be a dataset folder in the log directory that contains `meta/info.json` and more.

## Training

Setup your SSH config (`~/.ssh/config`) to allow the simple ssh and rsync commands to work:
```
Host gpu2
    HostName gpu2.ihmc.us
    User <username>
    ForwardAgent yes
```

Make sure you can login:
```
$ ssh gpu2
```

### Uploading your dataset

Make sure there's a `datasets` folder in your user home on gpu2:
```
gpu2:~ $ mkdir -p datasets
```

Back on your machine, use rsync to upload your dataset to the server:
```
dataset $ rsync -avz --exclude='.git' "$PWD" gpu2:~/datasets/
```

### Running training

Copy your locally cloned lerobot repo to the gpu server:
```
openpi $ rsync -avz --exclude={'.git','.idea','.vscode','.venv','.venvDocker','third_party','__pycache__/'} "$PWD" gpu2:~
```

Use tmux in order to train overnight without needing to leave a terminal open.

```
$ tmux ls               // list sessions to attach to
$ tmux new -s openpi   // create a new session
```
To detach, press Ctrl+B, then D.

Enter the docker environment:
```
~/openpi/scripts/docker/ihmc-train $ ./run.sh
```

Setup environment:
```
~/openpi (docker) $ ./setupTrain.sh
```

Compute stats:
```
openpi $ DATASET="/datasets/touch_handle_8/" uv run scripts/compute_norm_stats.py --config-name pi05_ihmc
```

Train policy:
```
DATASET="/datasets/touch_handle_8/" CUDA_VISIBLE_DEVICES=1,2,3 XLA_PYTHON_CLIENT_MEM_FRACTION=0.9 uv run scripts/train.py pi05_ihmc --exp-name=my_experiment
```

Use `--resume` to continue a previous run.

Use `Ctrl=B` then `[` to scroll up and down the log. Hit `q` to escape that mode.

To detach, press `Ctrl+B`, then `D`.
to reattach, use `tmux a -t openpi`.

