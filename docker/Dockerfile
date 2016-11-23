############################################################
# Dockerfile to build https://github.com/smj10j/southwest-checkin
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu:trusty

# File Author / Maintainer
MAINTAINER Stephen Johnson <steve@smj10j.net>

# Configurable variables
ENV DIRPATH /mnt
ENV REPO_NAME southwest-checkin
ENV GIT_URL https://github.com/smj10j/$REPO_NAME.git
ENV DEBIAN_FRONTEND noninteractive

# Expose the default port
EXPOSE 80

# Handy dandy packages before we fetch other packages
RUN apt-get update -q && \
    apt-get install -yq \
    wget \
    curl \
    python-software-properties \
    software-properties-common \
    apt-utils \
    build-essential \
    git \
    bison \
    unzip \
    autoconf \
    git-core \
    libpq5 \
    libpq-dev \
    zlib1g-dev \
    zlib1g \
    libffi-dev \
    openssl \
    libssl-dev \
    libgdbm3 \
    libgdbm-dev \
    libxml2-dev \
    libyaml-dev \
    libxslt1-dev \
    libsqlite3-dev \
    libncurses5 \
    libncurses5-dev \
    libreadline-dev \
    libreadline6 \
    libreadline6-dev \
    libcurl4-openssl-dev

# Get the latest postgres
# Get the latest nodejs
# Get the latest ruby    
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >/etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    curl -sL https://deb.nodesource.com/setup_7.x | /bin/bash && \
    apt-add-repository ppa:brightbox/ruby-ng 

RUN apt-get update -q && \
    apt-get install -yq \
    sqlite3 \
    postgresql \
    postgresql-client \
    postgresql-common \
    postgresql-contrib \
    postgresql-server-dev-all \
    tmux \
    nginx \
    nodejs \
    bundler \
    ruby2.3 \
    ruby2.3-dev \
    redis-server


# Remove artifacts
RUN apt-get autoremove -yq && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*



# Launch redis
RUN echo "Launching redis..." && \
    service redis-server restart
    
# Launch postgres
RUN echo "Launching postgres..." && \
    service postgresql restart


# Download our code
WORKDIR $DIRPATH
RUN git clone $GIT_URL $REPO_NAME

# Go into our new directory
WORKDIR $DIRPATH/$REPO_NAME

# Download the required libraries
RUN bundle install
    
# Create a db user and give them create privileges
USER postgres
RUN createuser root --createdb
USER root

# this fixes db encoding
RUN sed -i -e 's/*default/*default\n  template: template0/g' config/database.yml
    
# Seed the database
RUN rake db:setup && \
    rake db:create db:migrate db:seed && \
    rake dev:prime && \
    cp .env.example .env

# Launch sidekiq
RUN echo "Starting sidekiq..." && \
    bundle exec sidekiq &

# Run tests
RUN rspec

WORKDIR $DIRPATH/$REPO_NAME
ENTRYPOINT ["rails", "s" "-b" "0.0.0.0" "-p" "80" "-e" "development"]
