#!/bin/bash

apt-get update
apt-get install -y curl python python-dev build-essential
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py
python /tmp/get-pip.py
