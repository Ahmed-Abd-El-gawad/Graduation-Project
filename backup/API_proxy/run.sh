#!/bin/bash

# File to create or edit
SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
CONFIG_FILE="$SCRIPT_DIR/nginx.conf"
> $CONFIG_FILE
#echo $CONFIG_FILE
JSON_FILE="$SCRIPT_DIR/API_proxy.JSON"

FRONTEND_IP=$(jq '.frontend.ip' "$JSON_FILE")
FRONTEND_IP="${FRONTEND_IP//\"/}"
FRONTEND_PORT=$(jq '.frontend.port' "$JSON_FILE")
NUM_CONTROLLERS=$(jq '.controllers.number' "$JSON_FILE")
CONTROLLER_IP1=$(jq ".controllers.controller1.ip" "$JSON_FILE")
CONTROLLER_IP1="${CONTROLLER_IP1//\"/}"
PORT1=$(jq ".controllers.controller1.port" "$JSON_FILE")
CONTROLLER_IP2=$(jq ".controllers.controller2.ip" "$JSON_FILE")
CONTROLLER_IP2="${CONTROLLER_IP2//\"/}"
PORT2=$(jq ".controllers.controller2.port" "$JSON_FILE")

# Generate conf file
cat <<EOF >> $CONFIG_FILE
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log error;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    proxy_http_version 1.1;
    #proxy_method POST;
    include       /etc/nginx/mime.types;
    default_type  text/plain;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    upstream main_api {
        server $CONTROLLER_IP1:$PORT1;
    }

    upstream backup_api {
        server $CONTROLLER_IP2:$PORT2;
    }

    server {
        listen $FRONTEND_IP:$FRONTEND_PORT;

        location / {
            # Allow POST requests to the root URL
            allow all;
            #deny all;
            mirror /main_mirror;
            mirror /backup_mirror;
            proxy_set_header X-Original-URI \$request_uri;
        }

        # Mirror requests to the main API server
        location /main_mirror {
            internal;
            proxy_pass http://main_api\$request_uri;
            proxy_set_header Host \$host;
        }

        # Mirror requests to the backup API server
        location /backup_mirror {
            internal;
            proxy_pass http://backup_api\$request_uri;
            proxy_set_header Host \$host;
        }

        # Forward requests to the main API server
        location /main {
            proxy_pass http://main_api;
            proxy_set_header Host \$host;
        }

        # Forward requests to the backup API server
        location /backup {
            proxy_pass http://backup_api;
            proxy_set_header Host \$host;
        }
    }
}

EOF

echo "Configuration file has been edited"

# Check if the configuration file is valid
echo "$(nginx -t -c $CONFIG_FILE)"
cp -f $CONFIG_FILE /etc/nginx/nginx.conf 

# reload the configuration file
sudo kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
sudo service nginx stop
sudo service nginx start
sudo service nginx reload
echo "$(systemctl status nginx.service | grep Active)"

echo "The proxy is UP"

