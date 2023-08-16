#!/bin/bash

## 将用户添加到 docker 用户组： 你也可以将当前用户添加到 Docker 用户组，以便用户能够直接访问 Docker 套接字。首先，检查是否存在名为 "docker" 的用户组：最后，重新登录或注销并重新登录，以使用户组更改生效。
sudo groupadd docker

## 然后将当前用户添加到 "docker" 用户组：
sudo usermod -aG docker $USER

## 重启 Docker 服务： 在进行了用户组更改后，确保重启 Docker 服务以使更改生效：
sudo service docker restart

## 检查套接字权限： 确保 /var/run/docker.sock 文件的权限正确。运行以下命令检查：
ls -l /var/run/docker.sock

## 如果权限不正确，可以使用以下命令进行更正：
sudo chmod 666 /var/run/docker.sock
