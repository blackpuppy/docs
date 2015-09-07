# grunt watch:zh >> /home/vagrant/docs/watch.log 2>&1
# grunt watch:en >> /home/vagrant/docs/watch.log 2>&1

#!/usr/bin/tmux source-file
# use tmux
tmux new-session -d -s grunt-watch
# tmux split-window -d -t 0 -h

tmux send-keys -t 0 "grunt watch:rst" Enter
# tmux send-keys -t 1 "grunt watch:en" Enter
