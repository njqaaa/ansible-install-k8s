#!/bin/bash
export es_version="6.2.2"
ansible_dir=`pwd`
es_package_path='/tmp/src'
docker_package_path='/usr/local/src/'
es_dir="${ansible_dir}/roles/es/files/dir/"
if [[ -d ${es_package_path} ]];then
    rm -rf ${es_package_path}
fi
docker run --rm --name es-${es_version} -d njqaaa/es-package:${es_version} sleep 10
docker cp $(docker ps |grep es-${es_version} |awk '{print $1}'):${docker_package_path} /tmp/
cd ${es_package_path}
system=$(uname -s )
if [[ ${system} == "Darwin" ]];then
    find . -type f | xargs -I {} tar -xzf {}
else
    find . -type f | xargs -i tar -xzf {}
fi
find . -type f -maxdepth 1 | xargs rm

function set_version() {
    old_name=$(ls | grep "${keyword}")
    if [[ $? -eq 0 ]];then
        version=$(echo ${old_name} | awk -F ${keyword} '{print $2}')
        name=$(echo ${keyword} | egrep -o '[a-z]+' ) 
        echo $version > ${old_name}/version
        mv ${old_name} ${name} 
    fi
}

keyword="^elasticsearch-"
set_version 

keyword="^jdk"
set_version 

rm -rf ${es_dir}*
mv * ${es_dir}

