#!/usr/bin/env bash

# Author: Michael Curry (Kernelcurry)
# Website: http://www.kernelcurry.com
# Github: http://github.com/michaelcurry && http://github.com/kernelcurry
# Twitter: @kernelcurry

# Variables for colored output
COLOR_INFO='\e[1;34m'
COLOR_COMMENT='\e[0;33m'
COLOR_NOTICE='\e[1;37m'
COLOR_NONE='\e[0m' # No Color

# Intro
echo -e "${COLOR_INFO}"
echo "=============================="
echo "=        HHVM && HACK        ="
echo "=      Nginx && Laravel      ="
echo "=============================="
echo "= This script is to be used  ="
echo "= to install HHVM and HACK   ="
echo "= on ubuntu 12.0.4           ="
echo "=============================="
echo -e "${COLOR_NONE}"

# Basic Packages
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Baic Packages              ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get update
sudo apt-get install -y unzip vim git-core curl wget build-essential python-software-properties

# PPA && Repositories
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= PPA && Repositories        ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo add-apt-repository -y ppa:mapnik/boost
wget -O - http://nginx.org/keys/nginx_signing.key | sudo apt-key add -
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
echo deb http://nginx.org/packages/ubuntu/ precise nginx | sudo tee /etc/apt/sources.list.d/nginx.list
echo deb-src http://nginx.org/packages/ubuntu/ precise nginx | sudo tee -a /etc/apt/sources.list.d/nginx.list
echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list
sudo apt-get update

# Nginx
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing Nginx           ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y nginx

# HHVM
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing HHVM            ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y hhvm
sudo /etc/init.d/hhvm restart
sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

# Nginx Config
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Nginx Config               ="
echo "=============================="
echo -e "${COLOR_NONE}"
cat << EOF | sudo tee /etc/nginx/conf.d/laravel.conf
server {
    listen 80 default_server;

    root /vagrant/public;
    index index.html index.htm index.php index.hh;

    server_name localhost;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log error;

    charset utf-8;

    location / {
        rewrite ^/(.*)/$ /$1 redirect;
        try_files \$uri @fastcgi;
        access_log off;
    }

    location ~ \.(hh|php)$ {
        try_files \$uri @fastcgi;
        fastcgi_keep_conn on;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include        fastcgi_params;
    }

    location @fastcgi {
        fastcgi_keep_conn on;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME \$document_root/index.php;
        include        fastcgi_params;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { log_not_found off; access_log off; }

    error_page 404 /index.php;

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
EOF
sudo rm /etc/nginx/conf.d/default.conf
sudo service nginx reload

echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing Composer        ="
echo "=============================="
echo -e "${COLOR_NONE}"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo -e "${COLOR_INFO}"
echo "=============================="
echo "= Script Complete            ="
echo "=============================="
echo -e "${COLOR_NONE}"
