#!/bin/bash
function create_etchosts() {
    echo 127.0.0.1 localhost localhost.localdomain > ${temp_etchosts}
    echo ::1 localhost6 localhost6.localdomain >> ${temp_etchosts}
    cat ${base_dir}/hosts | grep ansible_host | awk '{print $2,$1}' | awk -F '=' '{print $2}' | grep -v '#' >> ${temp_etchosts}
}

function download() {
    export k8s_version="v1.11.6"
    docker run --rm --name k8s-${k8s_version} -d njqaaa/k8s-package:${k8s_version} sleep 10
    docker cp $(docker ps |grep k8s-${k8s_version} |awk '{print $1}'):${docker_package_path} ${base_dir}
    cd ${base_dir}/bin/
    find . -type f | xargs chmod +x
}

base_dir="/etc/ansible/"
temp_etchosts=${base_dir}/etchosts
docker_package_path='/tmp/bin/'

create_etchosts

download
