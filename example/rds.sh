#!/bin/bash

# initialize
export LC_ALL="en_US.UTF-8"
export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -yq  --no-install-recommends \
        build-essential language-pack-zh-hans git-core tig libcurl4-openssl-dev libcurl3

# install ruby
# https://www.brightbox.com/docs/ruby/ubuntu/
apt-get install -yq software-properties-common
apt-add-repository ppa:brightbox/ruby-ng

apt-get update && apt-get install -yq  --no-install-recommends ruby2.5 ruby2.5-dev
# Gem
GEM_SOURCES_CHINA=https://gems.ruby-china.com/
GEM_SOURCES_ORIGIN=https://rubygems.org/
gem sources --add $GEM_SOURCES_CHINA --remove $GEM_SOURCES_ORIGIN -v
echo 'gem: --no-document' | tee -a ~/.gemrc

# bundler
gem install bundler
bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}

# 创建后端部署用户和APP名称
read -p "Deploy User Name? " user_name
read -p "Application Name? " app_name

# Public Key zgt.pub
rsa_pub="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXqqura67hScy6V+A2r2YEUQXHZiwkFCR/4TLZGHNufYC+0j+2tZC4nTwjCCGrBIVLuE2ZEbvAItUt8XTKVLe+8vzT/oHsnopxCTEwe1bXOj+XeC9PAGZx5tQG9WKps9XqBovV6dw5NfOpjjEEKoTXCIZxlOqL9d94pEDM9hGvc/So1GtOiLEJSwNV19wIdQjTi3fyUhRhRey85usDon1blWilSPpUJQi2FMWhRoQn74DTiHOyR2P/y9sWN8uL/91wxOuxAiiCp1XsrPPNntZk8fTibkiW4pOxiwfI3HBX0XmAPOgDU3aR44qHw0dqQ4Z0CNj9payKUkWiS0sPickh zgt@zgt-Lenovo-Y430P"

# user
CHECK_USER=$(grep $user_name /etc/passwd | wc -l)

if [ ! $CHECK_USER -ge 1 ]; then
  useradd -m -G sudo,adm -s /bin/bash $user_name
  echo "${user_name} ALL=NOPASSWD:ALL" >> /etc/sudoers
su - $user_name  <<EOF
# SSH
mkdir ~/.ssh
echo ${rsa_pub} >> ~/.ssh/authorized_keys

sed  -i "1i # Rails Applicaton Configure\n" ~/.bashrc
sed  -i "1a export RAILS_ENV=production" ~/.bashrc
sed  -i "2a export RAILS_MASTER_KEY=" ~/.bashrc
EOF
fi
# app
app_path=/var/www/$app_name
if [ ! -d $app_path ]; then
mkdir -p $app_path
chown -R $user_name:$user_name $app_path
fi

echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "