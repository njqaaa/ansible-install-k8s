# 一件部署
git clone 本仓库，并重命名/etc/ansible
需要支持ssh至远程服务器（root用户）
默认安装的k8s版本v1.11.7，如需变更，请修改hosts文件中K8S_VER
hosts文件中deploy etcd kube-master lb kube-node 需手动维护
一键部署，执行./install-k8s-cluster.sh，包含各种基本工具检测
