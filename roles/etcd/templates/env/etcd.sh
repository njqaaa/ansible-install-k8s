export ETCDCTL_API=3
export ETCD_ENDPOINTS="https://127.0.0.1:2379"
export ETCD_CA_CERT_FILE="{{ ca_dir }}ca.pem"
export ETCD_CERT_FILE="{{ etcd_ca_dir }}etcd.pem"
export ETCD_KEY_FILE="{{ etcd_ca_dir }}etcd-key.pem"
