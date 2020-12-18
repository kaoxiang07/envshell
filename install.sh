#!/bin/bash

#1.mount disk
echo "-----Starting mount disks-----"
mdadm --create --verbose /dev/md0 --level=0 --raid-devices=4 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
mkfs.ext4 /dev/md0
mkdir /mnt
mount /dev/md0 /mnt
blkid=$(blkid | grep /dev/md0)
uuid=${blkid:18:36}
echo "/dev/disk/by-uuid/$uuid /mnt ext4 defaults 0 0" >> /etc/fstab
echo "-----Disks mounted-----"

#2.Configure env
envirConfig=/root/.bashrc
etcprofile=/etc/profile
etchosts=/etc/hosts
echo "-----Starting env configuration-----"
if [ ! -d $fil_proofs_parameter_cache ]
then
	mkdir -p /mnt/filecoin-proof-parameters
	echo "export FIL_PROOFS_PARAMETER_CACHE=/mnt/filecoin-proof-parameters" >> $envirConfig
fi

if [ ! -d $lotus_storage_path ]
then
	mkdir -p /mnt/local/.lotusstorage
	echo "export LOTUS_STORAGE_PATH=/mnt/local/.lotusstorage" >> $envirConfig
fi

if [ ! -d $lotus_path ]
then
	mkdir -p /mnt/local/lotus
	echo "export LOTUS_PATH=/mnt/local/lotus" >> $envirConfig
fi

if [ ! -d $worker_path ]
then
	mkdir -p /mnt/local/.worker
	echo "export WORKER_PATH=/mnt/local/.worker" >> $envirConfig
fi

if [ ! -d $tmpdir ]
then
	mkdir -p /mnt/local/tmp
	echo "export TMPDIR=/mnt/local/tmp" >> $envirConfig
fi

if [ ! -d $fil_proofs_parent_cache ]
then
	mkdir -p /mnt/filecoin-parents
	echo "export FIL_PROOFS_PARENT_CACHE=/mnt/filecoin-parents" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep BELLMAN_CUSTOM_GPU) ]
then
	echo "export BELLMAN_CUSTOM_GPU="GeForce RTX 3080:8704"" >> $envirConfig
fi

if [ -z $(cat $envirConfig | grep RUST_LOG) ]
then
	echo "export RUST_LOG=info" >> $envirConfig
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
echo "-----Env configuration finished!!!-----"

#3. install dependancy
echo "-----Starting dependancy installation-----"
add-apt-repository ppa:longsleep/golang-backports
apt update
apt install -y gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev ubuntu-drivers-common nvidia-driver-455 lrzsz ntpdate
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate ntp.aliyun.com
wget https://gomirrors.org/dl/go/go1.15.6.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> $envirConfig
source /root/.bashrc
echo "-----All finished!!-----"

#4.install fininshed, check installation

nvidiadrivers=$(nvidia-smi)
echo "$nvidiadrivers"

goversion=$(go version)
echo "$goversion"

disk=$(df -h)
echo "$disk"
