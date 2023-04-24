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
#二进制安装包下载地址：https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/



if [[  $type == "script"  ]];
then
    echo '执行脚本安装'
    sudo sh get-docker.sh --mirror Aliyun --VERSION 23.0.3
    echo '安装完成'
  else
    echo '默认执行二进制安装'
    sudo dpkg -i  *.deb
    echo '安装完成'
fi



if getent group docker >/dev/null; then
  echo "Group docker exists"
else
  echo "Group docker does not exist"
  sudo groupadd docker
fi

if groups | grep -q '\b<groupname>\b'; then
    echo "User is in group"
  else
    echo "User is not in group"
    sudo usermod -aG docker $USER
    # sudo newgrp docker
fi


sudo systemctl enable docker
sudo systemctl start docker

echo '测试docker安装结果：'
docker run --rm hello-world

echo '安装docker-compose'
sudo scp docker-compose-linux-x86_64 /usr/local/bin/docker-compose
sudo chmod 755  /usr/local/bin/docker-compose

sudo mkdir -p /etc/docker
sudo rm /etc/docker/daemon.json 
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://w151o9g2.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
