#! /bin/sh
nohup python /root/core/logger/logger_daemon.py &
nohup python /root/core/controls/controls_daemon.py &
echo "hello" > /etc/init.d/my