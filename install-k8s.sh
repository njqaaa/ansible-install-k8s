#!/bin/bash
export k8s_version="v1.8.8"
ansible_dir=`pwd`
k8s_package_path='/tmp/src'
docker_package_path='/usr/local/src/'
cert_bin="${ansible_dir}/roles/cert/files/bin/"
master_bin="${ansible_dir}/roles/k8s-master/files/bin/"
node_bin="${ansible_dir}/roles/k8s-node/files/bin/"
etcd_bin="${ansible_dir}/roles/etcd/files/bin/"
calico_bin="${ansible_dir}/roles/calico/files/bin/"
helm_bin="${ansible_dir}/roles/helm/files/bin/"
if [[ -d ${k8s_package_path} ]];then
    rm -rf ${k8s_package_path}
fi
docker run --rm --name k8s-${k8s_version} -d njqaaa/k8s-package:${k8s_version} sleep 10
docker cp $(docker ps |grep k8s-${k8s_version} |awk '{print $1}'):${docker_package_path} /tmp/
cp ${k8s_package_path}/k8s_bin/kubectl ${cert_bin}
cp ${k8s_package_path}/k8s_bin/kubectl ${helm_bin}
cp ${k8s_package_path}/k8s_bin/kubelet ${node_bin}
cp ${k8s_package_path}/k8s_bin/kube-proxy ${node_bin}
mv ${k8s_package_path}/cfssl/* ${cert_bin}
mv ${k8s_package_path}/k8s_bin/* ${master_bin}
mv ${k8s_package_path}/cni/* ${calico_bin}
mv ${k8s_package_path}/etcd_bin/* ${etcd_bin}
mv ${k8s_package_path}/helm/* ${helm_bin}

# 创建随机密码
admin_pass=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
cat hosts |grep "BASIC_AUTH_PASS="
if [[ $? -ne 0 ]];then
    echo BASIC_AUTH_PASS=\"${admin_pass}\" >> hosts
fi

# 创建随机token
bootstrap_token=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
cat hosts |grep "BOOTSTRAP_TOKEN="
if [[ $? -ne 0 ]];then
    echo BOOTSTRAP_TOKEN=\"${bootstrap_token}\" >> hosts
fi
function check_alive() {
    # check ssh是否正常
    echo check server and waiting...
    until ansible k8s-cluster -u root -m shell -a 'w' > /dev/null 2>&1; do sleep 2; printf "."; done
}
check_alive
#ansible-playbook 00-init.yaml
#echo reboot now
#check_alive
#
#ansible-playbook 01-common.yaml
#ansible-playbook 02-cert.yaml
#ansible-playbook 03-etcd.yaml
#ansible-playbook 04-docker.yaml
#ansible-playbook 05-calico.yaml
#ansible-playbook 06-k8s-master.yaml
#ansible-playbook 07-k8s-node.yaml
bash install-es.sh
ansible-playbook 08-es.yaml
ansible-playbook 09-todo.yaml
