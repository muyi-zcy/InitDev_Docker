#!/bin/bash

# 安装docker
# Version:Ubuntu 20.04.3 LTS

mkdir docker_install
cd docker_install

echo '下载docker安装脚本'
curl -fsSL get.docker.com -o get-docker.sh
echo '执行安装'
sudo sh get-docker.sh --mirror Aliyun

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker
sudo usermod -aG docker $USER

echo '测试docker安装结果：'
docker run --rm hello-world

echo '安装docker-compose'
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755  /usr/local/bin/docker-compose