# InitDev_Docker

```shell
## 当前路径
ubuntu@VM-12-3-ubuntu:~$ cd InitDev_Docker/
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ pwd
/home/ubuntu/InitDev_Docker

## 全部代码
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ ls
base-ubuntu    docker-compose-template.yml  docker_install  initDev.sh  kibana  nacos      redis     seata  staticIPConfig.sh
config-center  dockerConfig.sh              elk             jdk         mysql   README.md  rocketmq  sql
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ 
```
其中：
```shell
base-ubuntu：java环境基础镜像

docker-compose-template.yml：docker-compose模板模板，用于生成配置文件

docker_install：docker安装脚本存放

config-center、kibana、nacos、redis、seata、elk、mysql、rocketmq：容器的默认配置

sql： 一些容器所需的初始化sql

staticIPConfig.sh：静态IP初始化脚本

initDev.sh：初始化容器配置

dockerConfig.sh：安装docker环境
```

## 静态Ip
staticIPConfig.sh
输入ip

## 安装docker和docker-compose


```shell
## 安装docker和docker-compose
## 需要root账户操作
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ bash dockerConfig.sh 
ERROR: Unable to perform installation as non-root user.

## 提权
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ sudo bash dockerConfig.sh 

########################################
# 自动化安装docker、docker-compose 环境：
# docker version: Docker version 23.0.3, build 3e7cbfd
# docker-compose version: Docker Compose version v2.16.0
########################################

执行安装
# Executing docker install script, commit: a8a6b338bdfedd7ddefb96fe3e7fe7d4036d945a
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sh -c mkdir -p /etc/apt/keyrings && chmod -R 0755 /etc/apt/keyrings
+ sh -c curl -fsSL "https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg" | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
+ sh -c chmod a+r /etc/apt/keyrings/docker.gpg
+ sh -c echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.aliyun.com/docker-ce/linux/ubuntu focal stable" > /etc/apt/sources.list.d/docker.list
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin >/dev/null
+ sh -c docker version
Client: Docker Engine - Community
 Version:           23.0.3
 API version:       1.42
 Go version:        go1.19.7
 Git commit:        3e7cbfd
 Built:             Tue Apr  4 22:06:10 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          23.0.3
  API version:      1.42 (minimum version 1.12)
  Go version:       go1.19.7
  Git commit:       59118bf
  Built:            Tue Apr  4 22:06:10 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.20
  GitCommit:        2806fc1057397dbaeefbea0e4e17bddfbd388f38
 runc:
  Version:          1.1.5
  GitCommit:        v1.1.5-0-gf19387a
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/

================================================================================

Synchronizing state of docker.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable docker
groupadd: group 'docker' already exists
测试docker安装结果：
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:ffb13da98453e0f04d33a6eee5bb8e46ee50d08ebe17735fc0779d0349e889e9
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

安装docker-compose
{
  "registry-mirrors": ["https://w151o9g2.mirror.aliyuncs.com"]
}
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ 
```

查看安装结果
```shell
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ docker --version
Docker version 23.0.3, build 3e7cbfd
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ docker-compose -v
Docker Compose version v2.16.0

```

## 初始化容器部署配置
```shell
# 提供安装地址作为脚本参数
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ sudo bash initDev.sh /

########################################
#
#version：1.0
#author：muyi
#请提前完成docker和docker-compore安装
#
########################################

容器配置保存宿主机目录：/
创建桥接网络作为容器间通信
3c9acf3774b7724ddd62f08d56955fd553f6b61fd879d5f56842633123168ca5
是否删除所有容器(yes or no,default no): 
是否删除所有已关闭的容器(yes or no,default no): 
是否删除所有dangling数据卷和镜像(yes or no,default no): 
创建redis配置：
创建目录：/data/redis 完成
创建redis.conf完成
创建mysql配置
创建目录：/data/mysql 完成
创建my.cnf 完成
创建nacos配置
创建目录：/data/nacos 完成
创建目录：/data/nacos/init.d 完成
创建custom.properties 完成
创建zookeeper配置
创建目录：/data/zk 完成
创建rocketmq配置
创建目录：/data/rocketmq/broker 完成
创建broker.conf 完成
创建seata配置
创建目录：/data/seata/resources 完成
创建registry.conf 完成

```

## 部署容器
上一步执行完成，创建了一个docker-compose.yml文件：
```shell
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ sudo docker-compose up -d mysql redis zookeeper nacos minio
 ⠿ Container minio      Started                                                                                                                                      2.1s
 ⠿ Container zookeeper  Started                                                                                                                                      1.7s 
 ⠿ Container mysql_db   Started                                                                                                                                      2.2s 
 ⠿ Container redis      Started                                                                                                                                      2.0s 
 ⠿ Container nacos      Started   
```
查看运行情况
```shell
ubuntu@VM-12-3-ubuntu:~/InitDev_Docker$ sudo docker ps -a                                                                                                                 
CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS              PORTS                                                                                                                                                 NAMES
5a53f46b57be   nacos/nacos-server:2.0.0   "bin/docker-startup.…"   About a minute ago   Up About a minute   0.0.0.0:8848->8848/tcp, :::8848->8848/tcp, 0.0.0.0:9555->9555/tcp, :::9555->9555/tcp, 0.0.0.0:9848-9849->9848-9849/tcp, :::9848-9849->9848-9849/tcp   nacos
709fb3d96f76   nacos/nacos-mysql:8.0.16   "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                                                                  mysql_db
55424784a675   redis:5.0.0                "docker-entrypoint.s…"   About a minute ago   Up About a minute   0.0.0.0:6379->6379/tcp, :::6379->6379/tcp                                                                                                             redis
0515913ea662   zookeeper                  "/docker-entrypoint.…"   About a minute ago   Up About a minute   2888/tcp, 3888/tcp, 0.0.0.0:2181->2181/tcp, :::2181->2181/tcp, 8080/tcp                                                                               zookeeper
edb6b156d169   minio/minio                "/usr/bin/docker-ent…"   About a minute ago   Up About a minute   0.0.0.0:9000-9001->9000-9001/tcp, :::9000-9001->9000-9001/tcp                                                                                         minio
```