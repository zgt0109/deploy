#### 部署rails项目步骤

- ssh连接远程主机

    ssh root@example.com

- 设置字符集和apt-get安装软件禁用交互模式[示例](https://www.centos.bz/2017/12/ubuntu%E4%BD%BF%E7%94%A8apt-get%E5%AE%89%E8%A3%85%E8%BD%AF%E4%BB%B6%E7%A6%81%E7%94%A8%E4%BA%A4%E4%BA%92%E6%A8%A1%E5%BC%8F/)
```shell
    export LC_ALL="en_US.UTF-8"
    export DEBIAN_FRONTEND=noninteractive
```

- 添加新用户deploy（thrive888)
```shell
    useradd -m -G sudo,adm -s /bin/bash deploy
    echo "deploy ALL=NOPASSWD:ALL" >> /etc/sudoers
    # su - deploy

    # adduser deploy --ingroup sudo
    # groupadd deploy
```
- 安装ruby（https://www.brightbox.com/docs/ruby/ubuntu/）

```shell
    apt-get install -yq software-properties-common
    apt-add-repository ppa:brightbox/ruby-ng

    # 更新ubuntu并安装一些运行环境依赖
    apt-get update && apt-get install -yq --no-install-recommends build-essential
    apt-get install -yq language-pack-zh-hans git-core

    # 安装ruby2.5和相关软件
    apt-get install -yq ruby2.5 ruby2.5-dev\
    mysql-server mysql-client libmysqlclient-dev \
    redis-server redis-tools \
    nodejs nodejs-dev \
    nginx

    # Gem
    GEM_SOURCES_CHINA=https://gems.ruby-china.com/
    GEM_SOURCES_ORIGIN=https://rubygems.org/
    gem sources --add $GEM_SOURCES_CHINA --remove $GEM_SOURCES_ORIGIN -v

    # bundler
    gem install bundler
    bundle config mirror.${GEM_SOURCES_ORIGIN%/} ${GEM_SOURCES_CHINA%/}

    # nginx - 虚拟主机多域名配置为64（cat /etc/nginx/nginx.conf）
    sed  -i 's/#\s\+\(server_names_hash_bucket_size\)/\1/' /etc/nginx/nginx.conf
```


# 链接 nginx 配置文件 到 /etc/nginx/sites-enabled 中
# sudo ln -s /etc/nginx/sites-available/default default



创建生产数据库
```shell
create database if not exists db_name default charset utf8;

解决 Ubuntu 16.04 上不能直接用 root 用户登录

sudo mysql -u root -e "update mysql.user set plugin='mysql_native_password' WHERE User='root'";

sudo service mysql restart

sudo netstat -ant | grep 3306
```