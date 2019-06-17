#!/bin/bash

# 解决 Ubuntu 16.04 上mysql5.7不能直接用 root 用户登录
# eg  medusa_client_production
read -p "Production Database Name? " database_name
mysql -u root -e "create database if not exists $database_name default charset utf8;"
mysql -u root -e "update mysql.user set plugin='mysql_native_password' WHERE User='root';"
mysql -u root -e "update mysql.user set authentication_string=password('thrive') WHERE User='root';"
service mysql restart

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