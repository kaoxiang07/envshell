#!/bin/bash

envirConfig=/root/.bashrc
etcprofile=/etc/profile
etchosts=/etc/hosts

if [ ! -d $fil_proofs_parameter_cache ]
then
        mkdir -p $fil_proofs_parameter_cache
        echo "export FIL_PROOFS_PARAMETER_CACHE=/mnt/filecoin-proof-parameters" >> $envirConfig
fi

if [ ! -d $lotus_storage_path ]
then
        mkdir -p $lotus_storage_path
        echo "export LOTUS_STORAGE_PATH=/mnt/local/.lotusstorage" >> $envirConfig
fi

if [ ! -d $lotus_path ]
then
        mkdir -p $lotus_path
        echo "export LOTUS_PATH=/mnt/local/lotus" >> $envirConfig
fi

if [ ! -d $worker_path ]
then
        mkdir -p $worker_path
        echo "export WORKER_PATH=/mnt/local/.worker" >> $envirConfig
fi

if [ ! -d $tmpdir ]
then
        mkdir -p $tmpdir
        echo "export TMPDIR=/mnt/local/tmp" >> $envirConfig
fi

if [ ! -d $fil_proofs_parent_cache ]
then
        mkdir -p $fil_proofs_parent_cache
        echo "export FIL_PROOFS_PARENT_CACHE=/mnt/filecoin-parents" >> $envirConfig
fi

ipfs=$(cat $envirConfig | grep IPFS_GATEWAY)
echo "ipfs_gateway vvalues   is   : $ipfs"
if [ -z $ipfs ]
then
        echo "export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"" >> $envirConfig
fi

echo "ipfs_gateway  ect/profile values is :::   $ipfs"
ipfs=$(cat $etcprofile |grep IPFS_GATEWAY)
if [ -z $ipfs ]
then
        echo "export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"" >> $etcprofile
fi

if [ -z $(cat $envirConfig | grep BELLMAN_CUSTOM_GPU) ]
then
        echo "export BELLMAN_CUSTOM_GPU="GeForce RTX 3080:8704" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep RUST_LOG) ]
then
        echo "export RUST_LOG=info" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep RUST_BACKTRACE) ]
then
        echo "export RUST_BACKTRACE=full" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep GO111MODULE) ]
then
        echo "export GO111MODULE=on" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep GOPROXY)]
then
        echo "export GOPROXY=https://goproxy.cn" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep FIL_PROOFS_SDR_PARENTS_CACHE_SIZE)]
then
        echo "export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep RUSTUP_DIST_SERVER)]
then
        echo "export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep RUSTUP_UPDATE_ROOT)]
then
        echo "export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep FIL_PROOFS_MAXIMIZE_CACHING) ]
then
        echo "export FIL_PROOFS_MAXIMIZE_CACHING=1" >> $envirConfig
        echo "export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1" >> $envirConfig
fi

source /root/.bashrc
source /etc/profile

add-apt-repository ppa:longsleep/golang-backports
apt update
apt install gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev ubuntu-drivers-common nvidia-driver-455 lrzsz ntpdate
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate ntp.aliyun.com
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

echo "=======install finished, check go version========"

