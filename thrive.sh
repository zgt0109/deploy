#!/bin/bash

# initialize
GEM_SOURCES_CHINA=https://gems.ruby-china.com/
GEM_SOURCES_ORIGIN=https://rubygems.org/

user_name = 'thrive'
secret_key="15d8929ff6dfdce9b7d900464e07e2e789469fed0400215566a73d1a3161b11e754fdcd878c973faef664d7228c1bd8b3e62a7e4954f966cfbc829de4d85c9eb"

# read -p "Deploy User Name? " user_name
read -p "Application Name? " app_name

# user
CHECK_USER=$(grep $user_name /etc/passwd | wc -l)

if [ ! $CHECK_USER -ge 1 ]; then
  useradd -m -G sudo,adm -s /bin/bash $user_name
  echo "${user_name} ALL=NOPASSWD:ALL" >> /etc/sudoers
su - $user_name  <<EOF
# bundler
bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}

sed  -i "1i # Rails Applicaton Configure\n" ~/.bashrc
sed  -i "1a export RAILS_ENV=production" ~/.bashrc
EOF
fi
# app
app_path=/var/www/$app_name
if [ ! -d $app_path ]; then
mkdir -p $app_path
chown -R $user_name:$user_name $app_path
fi

echo -e "\e[31;43;1m All Done. Have a nice day!   \e[0m "
