#!/bin/bash

# Halt on any error
set -e

# Debug
# set -x

CWD=$(pwd)
cleanup() {
    cd "${CWD}"
    
    echo "Done!"
}
trap 'cleanup' SIGTERM ERR




cd "/Code/smj10j/southwest-checkin"

# echo "Launching redis..."
# redis-server /usr/local/etc/redis.conf &
# 
# echo "Launching postgres..."
# pg_ctl -D /usr/local/var/postgres-9.6.1 -l postgres-log.log start &


echo "Launching sidekiq..."
bundle exec sidekiq 2>&1 &

echo "Launching webserver..."
rails s 2>&1 & 

wait %1 %2

# Keep-alive# : update existing `sudo` time stamp until finished
# while read -n1; do 
#     sleep 1
# done 2>/dev/null
