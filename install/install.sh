#!/bin/bash

curl --silent --remote-name --location https://github.com/ceph/ceph/raw/quincy/src/cephadm/cephadm
chmod +x cephadm
sudo apt update
sudo apt -y install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
>   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
./cephadm add-repo --release quincy
./cephadm install
./cephadm install ceph-common
sudo mkdir -p /etc/ceph
cephadm bootstrap --mon-ip 192.168.198.200
ceph orch ps
ceph orch ps --daemon-type mon
ceph orch apply osd --all-available-devices
ceph config set global mon_allow_pool_size_one true
ceph osd pool set .mgr size 2 --yes-i-really-mean-it
ceph osd pool set .mgr size 1 --yes-i-really-mean-it
ceph osd pool set .mgr min_size 1
ceph osd pool create rbd 64 64 replicated
ceph osd pool set rbd min_size 1
ceph osd pool set rbd size 2 --yes-i-really-mean-it
ceph osd pool set rbd size 1 --yes-i-really-mean-it
rbd pool init rbd
ceph osd pool application enable rbd rbd
ceph health mute POOL_NO_REDUNDANCY
ceph config set global mon_allow_pool_delete true
