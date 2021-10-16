root@base:~/initShell# cat staticIPConfig.sh 
#!/bin/bash

# 修改静态IP
# Version:Ubuntu 20.04.3 LTS

echo '修改静态IP 开始'

# 查看本机IP
echo '本机IP：'
ip -o -f inet addr show | awk '/scope global/ {print $4}'

# 输入需要设置的静态IP
echo '请输入需要设置的静态IP：'
read ip

cat > /etc/netplan/00-installer-config.yaml <<EOF
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses: [$ip/24]
      dhcp4: false
      gateway4: 192.168.1.1
      nameservers:
                addresses:
                - 8.8.8.8
                search: []
  version: 2

EOF


sudo netplan --debug apply