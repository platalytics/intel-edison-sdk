#!/usr/bin/expect

# validate arguments

set timeout -1
set board_ip [lindex $argv 0]
set board_username [lindex $argv 1]
set board_password [lindex $argv 2]
set ssh_port [lindex $argv 3]
set device_id [lindex $argv 4]
set frontend_host [lindex $argv 5]

set remote_end "$board_username@$board_ip"

send_user "\nmake sure your yun board is connected to internet to install these dependencies"
send_user "\n- distribute\n- python-openssl\n- pip\n- paho-mqtt-1.1\n"

spawn ssh ${remote_end} -p ${ssh_port}
expect {
    -re ".*yes/no.*" {
        send "yes\r"; exp_continue
	-re ".*assword.*" { send "$board_password\r" }
    }
    -re ".*assword.*" { send "$board_password\r" }
}


expect "*~#" { send "curl -H \"Content-Type: application/json\" -X POST -d '{\"device_key\":\"'${device_id}'\",\"status\":\"true\",\"step\":\"3\"}' ${frontend_host}\r" }

# pre-installation
expect "*~#" { send "opkg update\r" }

# installing supported python libraries
expect "*~#" { send "pip install paho-mqtt\r" }

# setting permissions
expect "*~#" { send "chmod 775 /root/core/logger/logger_daemon.py\r" }
expect "*~#" { send "chmod 775 /root/core/controls/controls_daemon.py\r" }
expect "*~#" { send "chmod 775 /root/src/mqtt/mqtt-sender.py\r" }

# setting running daemons
expect "*~#" { send "curl -H \"Content-Type: application/json\" -X POST -d '{\"device_key\":\"'${device_id}'\",\"status\":\"true\",\"step\":\"4\"}' ${frontend_host}\r" }

expect "*~#" { send "echo ${device_id} 1>/root/key.conf\r" }
expect "*~#" { send "echo ${device_id}controlcallback 1>/root/controls.conf\r" }

# adding bootloader entries
expect "*~#" { send "curl -H \"Content-Type: application/json\" -X POST -d '{\"device_key\":\"'${device_id}'\",\"status\":\"true\",\"step\":\"5\"}' ${frontend_host}\r" }

expect "*~#" { send "mv /root/core/bootloader/logger.service /lib/systemd/system/logger.service\r"}
expect "*~#" { send "chmod 644 /lib/systemd/system/logger.service\r"}
expect "*~#" { send "chown root:root /lib/systemd/system/logger.service\r"}
expect "*~#" { send "systemctl daemon-reload\r"}
expect "*~#" { send "systemctl enable logger.service\r"}
expect "*~#" { send "systemctl start logger.service\r"}

# cleaning up
expect "*~#" { send "curl -H \"Content-Type: application/json\" -X POST -d '{\"device_key\":\"'${device_id}'\",\"status\":\"true\",\"step\":\"6\"}' ${frontend_host}\r" }
expect "*~#" { send "rm -rf /root/lib\r" }

# rebooting
expect "*~#" { send "curl -H \"Content-Type: application/json\" -X POST -d '{\"device_key\":\"'${device_id}'\",\"status\":\"true\",\"step\":\"7\"}' ${frontend_host}\r" }
## reboot here ##

# completion ack
expect "*~#" { send "curl -H \"Content-Type: application/json\" -X POST -d '{\"device_key\":\"'${device_id}'\",\"status\":\"true\",\"step\":\"8\"}' ${frontend_host}\r" }
expect "*~#" { send "exit\r" }

interact
