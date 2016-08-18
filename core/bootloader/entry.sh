#!/bin/bash

nohup python /root/core/logger/logger_daemon.py &
nohup python /root/core/controls/controls_daemon.py &