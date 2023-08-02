#!/bin/bash

# 定义镜像列表
images=(
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/kube-apiserver:v1.21.14"
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/kube-controller-manager:v1.21.14"
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/kube-scheduler:v1.21.14"
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/kube-proxy:v1.21.14"
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/pause:3.4.1"
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/etcd:3.4.13-0"
  "registry.cn-hangzhou.aliyuncs.com/kubeadm-iso/coredns:v1.8.0
"
)

# 循环下载镜像
for image in "${images[@]}"
do
  docker pull "$image"
done
