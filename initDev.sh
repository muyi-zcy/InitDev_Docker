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

if [ ! -n "$1" ] ;then
  echo "请输入宿主机配置目录"
  exit
  else
  echo "容器配置保存宿主机目录：$1"
fi

datapath=$1
if [[ $datapath == "/" ]];then
  datapath="";
  else
    if [ ${datapath:(1)} = "/" ]; then
        datapath=${datapath: -1}
    fi
fi


echo '创建桥接网络作为容器间通信'
docker network create my_net;


read -p "是否删除所有容器(yes or no,default no): " flagdelete
if [[ $flagdelete == "yes" ]];then
  echo "停止所有容器完成";
  docker stop $(docker ps -qa);

  echo "删除所有容器完成";
  docker rm $(docker ps -qa);
fi


read -p "是否删除所有已关闭的容器(yes or no,default no): " flagclose
if [[ $flagclose == "yes" ]];then
  docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm;
  echo "删除所有已关闭的容器完成";
fi

read -p "是否删除所有dangling数据卷和镜像(yes or no,default no): " flagdangling
if [[ $flagdangling == "yes" ]];then
  docker volume rm $(docker volume ls -qf dangling=true);
  echo "删除所有dangling数据卷(即无用的volume)成功"
  docker rmi $(docker images | grep "^<none>" | awk "{print $3}");
  echo "删除所有dangling镜像(即无tag的镜像)成功"
fi


echo '创建redis配置：';
if [ ! -d ${datapath}/data/redis ];then
  mkdir -p ${datapath}/data/redis
  echo "创建目录：${datapath}/data/redis 完成"
fi

if [ ! -f ${datapath}/data/redis/redis.conf ];then
  cp -f ./redis/redis.conf ${datapath}/data/redis;
  echo "创建redis.conf完成"
fi

echo '创建mysql配置';
if [ ! -d  ${datapath}/data/mysql ];then
  mkdir -p ${datapath}/data/mysql;
  echo "创建目录：${datapath}/data/mysql 完成"
fi

if [ ! -f ${datapath}/data/mysql/my.cnf ];then
  cp -f ./mysql/my.cnf ${datapath}/data/mysql;
  echo "创建my.cnf 完成"
fi

echo '创建nacos配置';
if [ ! -d  ${datapath}/data/nacos ];then
  mkdir -p ${datapath}/data/nacos;
  echo "创建目录：${datapath}/data/nacos 完成"
fi

if [ ! -d  ${datapath}/data/nacos/init.d ];then
  mkdir -p ${datapath}/data/nacos/init.d;
  echo "创建目录：${datapath}/data/nacos/init.d 完成"
fi

if [ ! -f ${datapath}/data/nacos/init.d/custom.properties ];then
  cp -f ./nacos/init.d/custom.properties ${datapath}/data/nacos/init.d/custom.properties;
  echo "创建custom.properties 完成"
fi


echo '创建zookeeper配置';
if [ ! -d  ${datapath}/data/zk ];then
  mkdir -p ${datapath}/data/zk;
  mkdir -p ${datapath}/data/zk/conf;
  echo "创建目录：${datapath}/data/zk 完成"
fi

echo '创建rocketmq配置';
if [ ! -d  ${datapath}/data/rocketmq/broker/conf ];then
  mkdir -p ${datapath}/data/rocketmq/broker/conf;
  echo "创建目录：${datapath}/data/rocketmq/broker/conf 完成"
fi

if [ ! -f ${datapath}/data/rocketmq/broker/conf/broker.conf ];then
  cp -f ./rocketmq/broker/conf/broker.conf ${datapath}/data/rocketmq/broker/conf/broker.conf;
  echo "创建broker.conf 完成"
fi


echo '创建seata配置';
if [ ! -d  ${datapath}/data/seata/resources ];then
  mkdir -p ${datapath}/data/seata/resources;
  echo "创建目录：${datapath}/data/seata/resources 完成"
fi

if [ ! -f ${datapath}/data/seata/resources/registry.conf ];then
  cp -f ./seata/config/registry.conf ${datapath}/data/seata/resources/registry.conf
  echo "创建registry.conf 完成"
fi


# 给data 文件夹赋予权限
chmod -R a+rwx  ${datapath}/data/
chmod -R a+rwx  ${datapath}/data/zk/conf

path=${datapath}
eval "cat <<EOF
$(< docker-compose-template.yml)
EOF
"  > docker-compose.yml

#docker-compose  -f docker-compose.yml up -d;
#
#docker exec -i $(docker ps -aqf 'name=mysql') mysql -u root -pdevMysqlPasswd <./sql/seata_init.sql
#docker exec -i $(docker ps -aqf 'name=mysql') mysql -u root -pdevMysqlPasswd <./sql/xxl-job.sql
#
#cd config-center/nacos;
#bash nacos-config.sh -h 127.0.0.1 -p 8848 -g SEATA_GROUP -t seata -u nacos -w nacos
#
#docker restart seata
# 说明 sh ./nacos-config.sh -h nacos地址 -p nacos端口 -g 所在组 -u nacos用户名 -w nacos密码
