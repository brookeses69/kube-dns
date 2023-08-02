#!/bin/bash

echo "关闭防火墙"
systemctl stop firewalld &> /dev/null
systemctl disable firewalld &> /dev/null
if systemctl status firewalld &> /dev/null; then
    echo "firewalld状态:"
    systemctl status firewalld
fi

systemctl stop iptables &> /dev/null
systemctl disable iptables &> /dev/null
if systemctl status iptables &> /dev/null; then
    echo "iptables状态:"
    systemctl status iptables
fi

systemctl stop ufw &> /dev/null
systemctl disable ufw &> /dev/null
if systemctl status ufw &> /dev/null; then
    echo "ufw状态:"
    systemctl status ufw
fi

sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo "修改源"
if [ -f /etc/yum.repos.d/CentOS-Base.repo ]; then
    last_modified=$(stat -c %Y /etc/yum.repos.d/CentOS-Base.repo)
    current_time=$(date +%s)
    days_since_last_modified=$(( (current_time - last_modified) / 86400 ))

    if [ $days_since_last_modified -ge 30 ]; then
        echo "源文件已存在且超过30天，跳过下载步骤"
    else
        sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        sudo yum clean all
        sudo yum makecache
    fi
else
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    sudo yum clean all
    sudo yum makecache
fi

# 等待最多10秒钟，尝试解除yum锁定
for i in {1..10}; do
    if [ -f /var/run/yum.pid ]; then
        echo "等待yum解锁..."
        sleep 1
    else
        break
    fi
done

# 检查是否仍然存在锁定
if [ -f /var/run/yum.pid ]; then
    echo "无法解除yum锁定。请稍后重试。"
    exit 1
fi

echo "安装 Docker..."
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache
sudo yum install -y docker-ce

echo "启动 Docker 服务..."
sudo systemctl enable docker --now

# 返回标准命令行提示符
echo "准备完成。"
