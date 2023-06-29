#!/bin/bash

# File to create or edit
#> $(HOME)/etc/haproxy/haproxy.cfg
#CONFIG_FILE="$(HOME)/etc/haproxy/haproxy.cfg"
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
CONFIG_FILE="$SCRIPT_DIR/haproxy.cfg"
> $CONFIG_FILE
#echo $CONFIG_FILE
JSON_FILE="$SCRIPT_DIR/takeover.JSON"

FRONTEND_IP=$(jq '.frontend.ip' "$JSON_FILE")
FRONTEND_PORT=$(jq '.frontend.port' "$JSON_FILE")
NUM_CONTROLLERS=$(jq '.controllers.number' "$JSON_FILE")

# Generate frontend section
cat <<EOF >> $CONFIG_FILE
global
	log /dev/log local0
	log /dev/log local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

defaults
	log global
	mode tcp
	option tcplog
	option dontlognull
	timeout connect 5000
	timeout client 50000
	timeout server 50000

frontend proxy_frontend
	bind $FRONTEND_IP:$FRONTEND_PORT
	default_backend controllers

EOF

# Generate backend section
cat <<EOF >> $CONFIG_FILE
backend controllers
	mode tcp
	balance roundrobin
	option tcp-check
	tcp-check connect port 6633
EOF

# Add controller servers 
for ((i=1;i<=$NUM_CONTROLLERS;i++)); do
if [ $i == 1 ]
then
CONTROLLER_IP=$(jq ".controllers.controller$i.ip" "$JSON_FILE")
PORT=$(jq ".controllers.controller$i.port" "$JSON_FILE")
cat <<EOF >> $CONFIG_FILE
	server ryu_controller$i $CONTROLLER_IP:$PORT check inter 3000
EOF
else
CONTROLLER_IP=$(jq ".controllers.controller$i.ip" "$JSON_FILE")
PORT=$(jq ".controllers.controller$i.port" "$JSON_FILE")
cat <<EOF >> $CONFIG_FILE
	server ryu_controller$i $CONTROLLER_IP:$PORT check inter 3000 backup
EOF
fi
done

echo "Configuration file has been edited"

# Check if the configuration file is valid
echo "$(haproxy -c -f $CONFIG_FILE)"

# restart the service to reload the configuration file
systemctl restart haproxy.service
echo "haproxy.service status (Should be running)"
echo "$(systemctl status haproxy.service | grep Active)"

# reload the configuration file
sudo haproxy -f $CONFIG_FILE -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)
echo "New configuration has been reloaded"

echo "The proxy is UP"

