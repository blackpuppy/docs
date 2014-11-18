#!/usr/bin/env bash

echo "update apt repository..."
apt-get update >/dev/null 2>&1
echo "Installing python-setuptools..."
sudo apt-get install -y python-setuptools >/dev/null 2>&1
echo "Installing easy_install..."
sudo apt-get install -y easy_install >/dev/null 2>&1
echo "Installing sphinx..."
sudo easy_install sphinx==1.2 >/dev/null 2>&1
echo "Installing sphinxcontrib-phpdomain..."
sudo easy_install sphinxcontrib-phpdomain >/dev/null 2>&1