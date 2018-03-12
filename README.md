# ansible一键安装k8s集群(centos 7)
## 默认需要资源如下
- ** 3 k8s-cluster(master) **
 kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet kubectl etcd etcdctl docker calico calico-ipam calicoctl loopback
***
- 3 ** k8s-cluster(node) **
kubelet kube-proxy docker calico calico-ipam calicoctl loopback
***
- 3 ** elasticsearch **
jdk elasticsearch elasticsearch-head bigdesk
***
- 1 ** loadbalance **
nginx(nginx相关配置文件在项目lb_config下)
***

## 实现功能如下
- ** harbor仓库 **
- ** eslasticsearch 集群 **
- ** EFK，搜集/var/log/containers/与journal信息 ，详情请看fluentd-es-configmap.yaml 需要fluentd执行的节点需在k8s-master上执行```kubectl label nodes <node-name> beta.kubernetes.io/fluentd-ds-ready=true``` **
- ** traefik，调用ingress **
- ** prometheus，ingress方式访问 **
- ** dashboard（readonly账号与key访问）**
- ~~ceph集群~~

## 安装集群
- ** clone该仓库，该机器需支持docker、git、ansible **
- ** 需修改hosts与roles/common/files/hosts roles/todo/files/addon/ingress/下的server_name**
- ** 所有集群先手动执行yum update -y (可忽略)**
- ** 替换roles/ceph/files/ssh/.ssh文件(可忽略) **
- ** 执行`install-k8s.sh`开始安装，其中es集群为非docker化 **

## 注意点
- ##### 统一服务器网卡名，例如eth0，否则需等待calico安装完成后，修改calico-node配置文件中改IP_AUTODETECTION_METHOD IP6_AUTODETECTION_METHOD
