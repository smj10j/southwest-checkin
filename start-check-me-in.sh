#!/bin/bash

# Halt on any error
set -e

# Debug
set -x

cleanup() {
    popd
    
    echo "Done!"
}
trap 'cleanup' SIGHUP SIGINT SIGTERM ERR




pushd /Code/External/southwest-checkin

echo "Launching redis..."
redis-server /usr/local/etc/redis.conf &

echo "Launching postgres..."
pg_ctl -D /usr/local/var/postgres-9.6.1 -l postgres-log.log start &

echo "Launching sidekiq..."
bundle exec sidekiq &

echo "Launching webserver..."
rails s


