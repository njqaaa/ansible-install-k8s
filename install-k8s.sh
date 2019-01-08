#!/bin/bash
export k8s_version="v1.11.6"
docker_package_path='/usr/local/src/'
base_dir="/etc/ansible/bin/"
docker run --rm --name k8s-${k8s_version} -d njqaaa/k8s-package:${k8s_version} sleep 10
docker cp $(docker ps |grep k8s-${k8s_version} |awk '{print $1}'):${docker_package_path} ${base_dir}
