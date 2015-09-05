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
\
# grunt watch:zh  > build/build.log 2>&1 &\
# grunt watch:en  > build/build.log 2>&1 &\
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


echo "**** Run Grunt watch as a service..."
echo '# gruntwatch - gruntwatch job file

description "watch for CakePHP Cookbook en/zh *.rst"
author "Zhu Ming <mingzhu.z@gmail.com>"
chdir /home/vagrant/docs

# Stanzas
#
# Stanzas control when and how a process is started and stopped
# See a list of stanzas here: http://upstart.ubuntu.com/wiki/Stanzas#respawn

# When to start the service
start on runlevel [2345]

# When to stop the service
stop on runlevel [016]

# Automatically restart process if crashed
respawn

# Essentially lets upstart know the process will detach itself to the background
expect fork

# Run before process
pre-start script
end script

# Start the process
script
	grunt watch:zh > /home/vagrant/docs/watch.log
	grunt watch:en > /home/vagrant/docs/watch.log
end script
' > /etc/init/gruntwatch.conf
chmod g-w /etc/init/gruntwatch.conf
