#!/bin/bash

# initialize
export LC_ALL="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -yq  --no-install-recommends \
        build-essential language-pack-zh-hans git tig nginx libcurl4-openssl-dev libcurl3

# nginx
sed  -i 's/#\s\+\(server_names_hash_bucket_size\)/\1/' /etc/nginx/nginx.conf

# 前端安装nodejs 和 yarn
wget -qO- https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get update && apt-get install -y nodejs

# install ruby
# https://www.brightbox.com/docs/ruby/ubuntu/
apt-get install -yq software-properties-common
apt-add-repository ppa:brightbox/ruby-ng

apt-get update && apt-get install -yq  --no-install-recommends ruby2.6 ruby2.6-dev
# 设置项目所需ruby的正确版本
apt-get install ruby-switch
ruby-switch --set ruby2.6

# Gem
GEM_SOURCES_CHINA=https://gems.ruby-china.com/
GEM_SOURCES_ORIGIN=https://rubygems.org/
gem sources --add $GEM_SOURCES_CHINA --remove $GEM_SOURCES_ORIGIN -v
echo 'gem: --no-document' | tee -a ~/.gemrc

# bundler
gem install bundler
bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}

# install mysql and redis
apt-get install -yq mysql-server mysql-client libmysqlclient-dev
apt-get install -yq redis-server redis-tools

echo -e "\e[31;43;1m All Done. Have a nice day! \e[0m "