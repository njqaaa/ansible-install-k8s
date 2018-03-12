## 使用ceph rbd之前，所有node节点需要安装ceph-common
### 修改harbor/pv/ceph-secret.yaml中的key
`登录ceph-manager服务器，执行ceph auth get-key client.admin|base64`

#### 注意点：ceph rbd不支持ReadWriteMany，如果要支持，请使用cephfs

## 请先ansible-playbook执行[90-ceph.yaml](https://github.com/njqaaa/ansible-install-k8s/blob/master/90-ceph.yaml)
## 集群信息
```bash
ceph-manager
ceph-mon-1
ceph-osd-1
ceph-osd-2
```

## 以下所有操作都在ceph-manager上执行
``` bash
### 创建监控节点
su - ceph
cd /etc/ceph
ceph-deploy new ceph-mon-1
echo "osd pool default size = 2" >> /etc/ceph/ceph.conf
echo "rbd_default_features = 1" >> /etc/ceph/ceph.conf
### 所有机器安装ceph
ceph-deploy install ceph-manager ceph-mon-1 ceph-osd-1 ceph-osd-2
ceph-deploy mon create-initial

### 启动并激活osd
ceph-deploy osd prepare ceph-osd-1:/data/osd ceph-osd-2:/data/osd
ceph-deploy osd activate ceph-osd-1:/data/osd ceph-osd-2:/data/osd

### 把管理节点的配置文件与keyring同步至其它节点
ceph-deploy --overwrite-conf admin ceph-mon-1 ceph-osd-1 ceph-osd-2

### 验证集群健康
ceph health
```

### 创建rbd，参考如下：
``` bash
ceph osd pool create harbor 100
ceph osd pool set harbor  pgp_num 100
ceph osd lspools
ceph osd pool set harbor size 2
rbd create -p harbor --size 100000 storage
rbd -p harbor info storage
rbd -p harbor map storage
```