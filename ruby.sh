#!/bin/bash

# initialize
GEM_SOURCES_CHINA=https://gems.ruby-china.com/
GEM_SOURCES_ORIGIN=https://rubygems.org/
export LC_ALL="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive

# https://www.brightbox.com/docs/ruby/ubuntu/
apt-get update
apt-get install -yq software-properties-common
apt-add-repository ppa:brightbox/ruby-ng

apt-get update && apt-get install -y  --no-install-recommends \
      build-essential \
      language-pack-zh-hans \
      git-core \
      # ruby2.5 ruby2.5-dev\
      ruby2.3 ruby2.3-dev\
      mysql-server mysql-client libmysqlclient-dev \
      redis-server redis-tools \
      nodejs nodejs-dev \
      nginx

# Gem
gem sources --add $GEM_SOURCES_CHINA --remove $GEM_SOURCES_ORIGIN -v
echo 'gem: --no-document' | tee -a ~/.gemrc

# bundler
gem install bundler
bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}

# nginx
sed  -i 's/#\s\+\(server_names_hash_bucket_size\)/\1/' /etc/nginx/nginx.conf

echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "
