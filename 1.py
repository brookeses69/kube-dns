import os

list1=["kube-apiserver","kube-controller-manager","kube-scheduler","kube-proxy","pause","etcd","coredns"
]
for item in list1:#直接遍历
    path = item
    print(path)
    os.mkdir(path)
