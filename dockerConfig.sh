#!/bin/bash

# 安装docker
# Version:Ubuntu 20.04 LTS

if [ $USER != "root" ]
then
    echo "ERROR: Unable to perform installation as non-root user."
    exit
fi

echo '
########################################
# 自动化安装docker、docker-compose 环境：
# docker version: Docker version 23.0.3, build 3e7cbfd
# docker-compose version: Docker Compose version v2.16.0
########################################
'

cd docker_install

#
#echo '下载docker安装脚本'
#curl -fsSL get.docker.com -o get-docker.sh

echo '执行安装'
sudo sh get-docker.sh --mirror Aliyun

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

echo '测试docker安装结果：'
docker run --rm hello-world

echo '安装docker-compose'
scp docker-compose-linux-x86_64 /usr/local/bin/docker-compose
chmod 755  /usr/local/bin/docker-compose

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://w151o9g2.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
