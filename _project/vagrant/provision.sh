#!/usr/bin/env bash

echo "Installing sphinx..."
apt-get update >/dev/null 2>&1
sudo apt-get install -y python-setuptools >/dev/null 2>&1
sudo apt-get install -y easy_install >/dev/null 2>&1
sudo easy_install sphinx >/dev/null 2>&1
sudo easy_install sphinxcontrib-phpdomain >/dev/null 2>&1