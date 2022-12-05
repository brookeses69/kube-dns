import os
import re

a = ["kube-apiserver:v1.25.4",
"kube-controller-manager:v1.25.4",
"kube-scheduler:v1.25.4",
"kube-proxy:v1.25.4",
"pause:3.8",
"etcd:3.5.4-0",
"coredns:v1.9.3",]  # 二级目录需要删除一个级别
for item in a:#直接遍历
    lst = re.findall(r".*:", item)
    lst = lst[0].replace(':', '')
    os.mkdir(lst)
