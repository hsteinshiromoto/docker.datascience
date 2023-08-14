#!/usr/bin/env bash

echo "Starting VSCode"
code-server --port 8080 --bind-addr 0.0.0.0 &


echo "Starting Jupyter Lab"
jupyter lab --port=8888 --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token='' --NotebookApp.password=''
