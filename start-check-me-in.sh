#!/bin/bash

# Halt on any error
set -e

# Debug
set -x

CWD=$(pwd)
cleanup() {
    log "Failed with error code $3 at $1:$2"
    cd "${CWD}"
    exit 1
}
trap 'cleanup "${BASH_SOURCE#*\./}" ${LINENO} $?' SIGTERM ERR

log() {
    echo "$(date +'%x %X') $1"
}

cd "/Code/smj10j/southwest-checkin"

export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init -)"

# echo "Launching redis..."
# redis-server /usr/local/etc/redis.conf &
#
# echo "Launching postgres..."
# pg_ctl -D /usr/local/var/postgres-9.6.1 -l postgres-log.log start &


## ENVIRONMENT and SECRET_KEY_BASE are set in launchctl plist net.smj10j.mac.southwest-checkin

echo "Installing any needed bundles..."
bundle install

log "Launching sidekiq..."
bundle exec sidekiq 2>&1 &

log "Launching webserver..."
bundle exec rails s -e "${ENVIRONMENT}" 2>&1 &

wait %1 %2

# Keep-alive# : update existing `sudo` time stamp until finished
# while read -n1; do
#     sleep 1
# done 2>/dev/null



cd "${CWD}"
log "Exited cleanly"
