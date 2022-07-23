#!/bin/bash

echo '
########################################
#
#version：1.0
#author：muyi
#请提前完成docker和docker-compore安装
#
########################################
'
echo '创建桥接网络作为容器间通信'
docker network create my_net;
echo '停止所有容器';
docker stop $(docker ps -qa);
echo '删除所有容器';
docker rm $(docker ps -qa);
echo '创建redis.conf';
mkdir -p ~/data/redis;
cp -f ./redis/redis.conf ~/data/redis;
echo '创建my.cnf';
mkdir -p ~/data/mysql;
cp -f ./mysql/my.cnf ~/data/mysql;
echo '创建nacos配置';
mkdir -p ~/data/nacos;
mkdir -p ~/data/nacos/init.d;
cp -f ./nacos/init.d/custom.properties ~/data/nacos/init.d/custom.properties;
mkdir -p ~/data/zk;

mkdir -p ~/data/rocketmq/broker;
cp -f ./rocketmq/broker/broker.conf ~/data/rocketmq/broker/broker.conf;

mkdir -p ~/data/seata/resources/
cp -f ./seata/config/registry.conf ~/data/seata/resources/registry.conf

# 删除所有dangling数据卷(即无用的volume)
docker volume rm $(docker volume ls -qf dangling=true);
# 删除所有dangling镜像(即无tag的镜像)：
docker rmi $(docker images | grep "^<none>" | awk "{print $3}");
#删除所有关闭的容器
docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm;

# 给data 文件夹赋予权限
chmod -R a+rwx  ~/data/

docker-compose  -f docker-compose.yml up -d;

docker exec -i $(docker ps -aqf 'name=mysql') mysql -u root -pdevMysqlPasswd <./sql/seata_init.sql
docker exec -i $(docker ps -aqf 'name=mysql') mysql -u root -pdevMysqlPasswd <./sql/xxl-job.sql

cd config-center/nacos;
bash nacos-config.sh -h 127.0.0.1 -p 8848 -g SEATA_GROUP -t seata -u nacos -w nacos

docker restart seata
# 说明 sh ./nacos-config.sh -h nacos地址 -p nacos端口 -g 所在组 -u nacos用户名 -w nacos密码
