#!/bin/bash

# 定义函数执行脚本1
function run_script_1() {
    echo "执行脚本1"
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    sed -i 's/#Port 22/Port 2222/g' /etc/ssh/sshd_config
    systemctl restart sshd
}

# 定义函数执行脚本2
function run_script_2() {
    echo "执行脚本2"
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
}

# 定义函数执行脚本3
function run_script_3() {
    echo "执行脚本3"
    sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    sudo yum clean all
    sudo yum makecache
    sudo yum -y install wget
}

# 根据参数选择执行不同的脚本
if [[ $# -eq 0 ]]; then
    echo "请提供脚本编号作为参数"
    echo "Usage: ./merged_script.sh <script_number>"
    echo "Available script numbers: 1, 2, 3"
    exit 1
fi

case $1 in
    1)
        run_script_1
        ;;
    2)
        run_script_2
        ;;
    3)
        run_script_3
        ;;
    *)
        echo "无效的脚本编号"
        echo "可用的脚本编号：1, 2, 3"
        exit 1
        ;;
esac
