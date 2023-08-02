#!/bin/bash

# 关闭 Swap
swapoff -a

# 注释 /etc/fstab 文件中的 Swap 相关行
sed -i.bak '/swap/s/^/#/' /etc/fstab

# 输出修改后的 /etc/fstab 文件内容
cat /etc/fstab

# 重载更新后的 /etc/fstab 文件
mount -a

# 再次检查 Swap 使用情况确认关闭成功
swapon --show

echo "设置内核参数"
cat <<EOF >> /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system


# 添加 Kubernetes 源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 移除旧版本 Kubernetes
yum remove -y kubelet kubeadm kubectl

# 安装指定版本的 Kubernetes
yum install -y kubelet-1.21.0 kubeadm-1.21.0 kubectl-1.21.0

# 设置开机启动并启动 kubelet 服务
systemctl enable kubelet && systemctl start kubelet

kubeadm config images list
