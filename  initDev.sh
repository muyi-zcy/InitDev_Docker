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
docker network create my_net

echo '停止所有容器'
docker stop $(docker ps -qa)

echo '删除所有容器'
docker rm $(docker ps -qa)

echo '创建redis.conf'
mkdir -p ~/data/redis
cp -f ./redis/redis.conf ~/data/redis

echo '创建my.cnf'
mkdir -p ~/data/mysql
cp -f ./mysql/my.cnf ~/data/redis


echo '创建nacos配置'
mkdir -p ~/data/nacos
mkdir -p ~/data/nacos/init.d
cp -f ./nacos/init.d/custom.properties ~/data/nacos/init.d

rm -rf docker-compose.yml;

echo "创建docker-compose.yml 模板------"
cat <<EOF > docker-compose.yml
version: '3'
services:
   redis:
     image: redis:5.0.0
     restart: "always"
     networks:
       - my_net
     container_name: redis
     command: redis-server --requirepass 123456 --appendonly yes
     ports:
       - "6379:6379"
     volumes:
       - /root/data/redis/data:/data
       - /root/data/redis/redis.conf:/etc/redis/redis.conf
   mysql:
     image: mysql:5.7.26
     restart: "always"
     networks:
       - my_net
     container_name: mysql
     command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
     environment:
     	- TZ=Asia/Shanghai
        - MYSQL_ROOT_PASSWORD: 123456
        - MYSQL_DATABASE=nacos_config
        - MYSQL_USER=nacos
        - MYSQL_PASSWORD=nacos
     ports:
       - '3306:3306'
     volumes:
       - /root/data/mysql/data/db:/var/lib/mysql"
       - /root/data/mysql/data/conf:/etc/mysql/conf.d"
   zookeeper:
     image: zookeeper
     restart: always
     networks:
       - my_net
     container_name: zookeeper
     volumes:
       - /root/data/zk/config:/conf
       - /root/data/zk/data:/data
       - /root/data/zk/logs:/datalog
    ports: 
      - "2181:2181"
   nacos:
     image: nacos/nacos-server:2.0.0
     container_name: nacos
     hostname: nacos
     env_file:
       - ./nacos/nacos-standlone-mysql.env
     environment:
       - TZ=Asia/Shanghai
     volumes:
       - /root/data/nacos/logs/:/home/nacos/logs
       - /root/data/nacos/init.d/custom.properties:/home/nacos/init.d/custom.properties
     ports:
       - 8848:8848
       - 9555:9555
     depends_on:
       - mysql
     restart: always
     networks:
       - my_net
   sentinel:
     image: bladex/sentinel-dashboard:1.8.0
     container_name: sentinel
     hostname: sentinel
     ports:
       - 8858:8858
     environment:
       - TZ=Asia/Shanghai
     restart: always
     networks:
       - my_net
   seata:
     image: seataio/seata-server:1.4.1
     container_name: seata
     hostname: server
     ports:
       - 8091:8091
     environment:
       - SEATA_CONFIG_NAME=file:/root/seata-config/registry
       - SEATA_IP=127.0.0.1
       - SEATA_PORT=8091
       - TZ=Asia/Shanghai
     volumes:
       - /root/data/seata/config:/root/seata-config
     depends_on:
       - mysql
       - nacos
     restart: always
     networks:
       - my_net

networks
  my_net:
    external: true
EOF

docker-compose  -f docker-compose.yml up -d

cd config-center/nacos

sh ./nacos-config.sh -h 127.0.0.1 -p 8848 -g SEATA_GROUP -u nacos -w nacos

# 说明 sh ./nacos-config.sh -h nacos地址 -p nacos端口 -g 所在组 -u nacos用户名 -w nacos密码
