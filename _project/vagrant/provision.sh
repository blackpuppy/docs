#!/usr/bin/env bash

# locale error when build with sphinx, or installing python-setuptools
# solution: http://stackoverflow.com/questions/10921430/fresh-installation-of-sphinx-quickstart-fails


echo "Setting timezone to Asia/Shanghai ..."
echo Asia/Shanghai > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

echo "Setting locale to UTF-8 ..."
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8


echo "**** export locale environment variables for root..."
sed -i '$a \
\
export LC_ALL=en_US.UTF-8\
export LANG=en_US.UTF-8
' ~/.profile
source ~/.profile

echo "**** export locale environment variables for vagrant..."
sed -i '$a \
\
SSH_ENV="$HOME/.ssh/environment"\
\
function start_agent {\
	echo "Initialising new SSH agent..."\
	/usr/bin/ssh-agent | sed \x27s/^echo/#echo/\x27 > "${SSH_ENV}"\
	echo succeeded\
	chmod 600 "${SSH_ENV}"\
	. "${SSH_ENV}" > /dev/null\
	/usr/bin/ssh-add;\
}\
\
# Source SSH settings, if applicable\
\
if [ -f "${SSH_ENV}" ]; then\
	. "${SSH_ENV}" > /dev/null\
	#ps ${SSH_AGENT_PID} doesn not work under cywgin\
	ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {\
		start_agent;\
	}\
else\
	start_agent;\
fi\
\
export LC_ALL=en_US.UTF-8\
export LANG=en_US.UTF-8\
\
cd ~/docs\
' /home/vagrant/.profile


echo "**** update apt repository..."
apt-get update

echo "**** Installing vim..."
apt-get -y install vim

echo "**** Installing python-setuptools..."
apt-get install -y python-setuptools

# echo "**** Installing easy_install..."
# apt-get install -y easy_install

echo "**** Installing sphinx..."
easy_install sphinx==1.2.3

echo "**** Installing sphinxcontrib-phpdomain..."
easy_install sphinxcontrib-phpdomain

echo "**** Installing Travis CI Command Line Client..."
apt-get install -y ruby-full gem
gem install travis

echo "**** Installing Node.js, npm & Grunt..."
apt-get install -y nodejs npm
ln -s /usr/bin/nodejs /usr/bin/node
npm install -g grunt-cli
cd /home/vagrant/docs
npm install
