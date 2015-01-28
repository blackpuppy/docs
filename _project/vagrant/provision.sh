#!/usr/bin/env bash

# locale error when build with sphinx, or installing python-setuptools
# solution: http://stackoverflow.com/questions/10921430/fresh-installation-of-sphinx-quickstart-fails


echo "**** export locale environment variables for root..."
sed -i '$a \
\
export LC_ALL=en_US.UTF-8\
export LANG=en_US.UTF-8' ~/.profile
source ~/.profile

echo "**** export locale environment variables for vagrant..."
sed -i '$a \
\
export LC_ALL=en_US.UTF-8\
export LANG=en_US.UTF-8\
\
cd /docs
' /home/vagrant/.profile


echo "**** Installing vim..."
sudo apt-get -y install vim


echo "**** update apt repository..."
sudo apt-get update >/dev/null 2>&1

echo "**** Installing python-setuptools..."
sudo apt-get install -y python-setuptools >/dev/null 2>&1

# echo "**** Installing easy_install..."
# sudo apt-get install -y easy_install >/dev/null 2>&1

echo "**** Installing sphinx..."
sudo easy_install sphinx==1.2.3 >/dev/null 2>&1

echo "**** Installing sphinxcontrib-phpdomain..."
sudo easy_install sphinxcontrib-phpdomain >/dev/null 2>&1
