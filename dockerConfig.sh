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
