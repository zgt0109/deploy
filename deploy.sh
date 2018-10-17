#!/bin/bash

# initialize
GEM_SOURCES_CHINA=https://gems.ruby-china.com/
GEM_SOURCES_ORIGIN=https://rubygems.org/
# Public Key zgt.pub
rsa_pub="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXqqura67hScy6V+A2r2YEUQXHZiwkFCR/4TLZGHNufYC+0j+2tZC4nTwjCCGrBIVLuE2ZEbvAItUt8XTKVLe+8vzT/oHsnopxCTEwe1bXOj+XeC9PAGZx5tQG9WKps9XqBovV6dw5NfOpjjEEKoTXCIZxlOqL9d94pEDM9hGvc/So1GtOiLEJSwNV19wIdQjTi3fyUhRhRey85usDon1blWilSPpUJQi2FMWhRoQn74DTiHOyR2P/y9sWN8uL/91wxOuxAiiCp1XsrPPNntZk8fTibkiW4pOxiwfI3HBX0XmAPOgDU3aR44qHw0dqQ4Z0CNj9payKUkWiS0sPickh zgt@zgt-Lenovo-Y430P"
secret_key="15d8929ff6dfdce9b7d900464e07e2e789469fed0400215566a73d1a3161b11e754fdcd878c973faef664d7228c1bd8b3e62a7e4954f966cfbc829de4d85c9eb"

# read -p "Public Key? " rsa_pub
read -p "Deploy User Name? " user_name
read -p "Application Name? " app_name

# user
CHECK_USER=$(grep $user_name /etc/passwd | wc -l)

if [ ! $CHECK_USER -ge 1 ]; then
  useradd -m -G sudo,adm -s /bin/bash $user_name
  echo "${user_name} ALL=NOPASSWD:ALL" >> /etc/sudoers
su - $user_name  <<EOF
# bundler
bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}
# SSH
mkdir ~/.ssh
echo ${rsa_pub} >> ~/.ssh/authorized_keys
sed  -i "1i # Rails Applicaton Configure\n" ~/.bashrc
sed  -i "1a export RAILS_ENV=production" ~/.bashrc
sed  -i "1a export SECRET_KEY_BASE=${secret_key}" ~/.bashrc
EOF
fi
# app
app_path=/var/www/$app_name
if [ ! -d $app_path ]; then
mkdir -p $app_path
chown -R $user_name:$user_name $app_path
fi

echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "







