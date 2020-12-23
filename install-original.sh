#!/bin/bash

#1.mount disk
#echo "-----------------Starting mount disks-----------------"
#raidmd0=$(fdisk -l | grep /dev/md0)
#raidmd127=$(fdisk -l | grep /dev/md127)
#if [ -z "$raidmd0" ] && [ -z "$raidmd127" ]
#then
#	mdadm --create --verbose /dev/md0 --level=0 --raid-devices=4 /dev/nvme0n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
#	mkfs.ext4 /dev/md0
#	mkdir /mnt
#	mount /dev/md0 /mnt
#	blkid=$(blkid | grep /dev/md0)
#	uuid=${blkid:18:36}
#	echo "/dev/disk/by-uuid/$uuid /mnt ext4 defaults 0 0" >> /etc/fstab
#	echo "-----------------Disks mounted-----------------"
#else
#	echo "-----------------Already mounted-----------------"
#fi

#2.Configure env
envirConfig=/root/.bashrc
etcprofile=/etc/profile
etchosts=/etc/hosts
echo "-----------------Starting env configuration-----------------"
echo "91.189.88.142 archive.ubuntu.com" >> $etchosts
if [ ! -d $fil_proofs_parameter_cache ]
then
	mkdir -p /home/storage/filecoin-proof-parameters
	echo "export FIL_PROOFS_PARAMETER_CACHE=/home/storage/filecoin-proof-parameters" >> $envirConfig
fi

if [ ! -d $lotus_storage_path ]
then
	mkdir -p /home/storage/lotuswork/lotusstorage
	echo "export LOTUS_STORAGE_PATH=/home/storage/lotuswork/lotusstorage" >> $envirConfig
fi

if [ ! -d $lotus_path ]
then
	mkdir -p /home/storage/lotuswork/lotus
	echo "export LOTUS_PATH=/home/storage/lotuswork/lotus" >> $envirConfig
fi

if [ ! -d $worker_path ]
then
	mkdir -p /home/storage/lotuswork/lotusworker
	echo "export WORKER_PATH=/home/storage/lotuswork/lotusworker" >> $envirConfig
fi

if [ ! -d $tmpdir ]
then
	mkdir -p /home/storage/lotuswork/tmpdir
	echo "export TMPDIR=/home/storage/lotuswork/tmpdir" >> $envirConfig
fi

if [ ! -d $fil_proofs_parent_cache ]
then
	mkdir -p /home/storage/cache
	echo "export FIL_PROOFS_PARENT_CACHE=/home/storage/cache" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep BELLMAN_CUSTOM_GPU)" ]
then
	echo "export BELLMAN_CUSTOM_GPU="GeForce GTX 2080Ti:4352"" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep RUST_LOG)" ]
then
	echo "export RUST_LOG=info" >> $envirConfig
	echo "export RUST_BACKTRACE=full" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep GO111MODULE)" ]
then
	echo "export GO111MODULE=on" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep GOPROXY)" ]
then
	echo "export GOPROXY=https://goproxy.cn" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep FIL_PROOFS_SDR_PARENTS_CACHE_SIZE)" ]
then
	echo "export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep RUSTUP_DIST_SERVER)" ]
then
	echo "export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep RUSTUP_UPDATE_ROOT)" ]
then
	echo "export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup" >> $envirConfig
fi

if [ -z "$(cat $envirConfig | grep FIL_PROOFS_MAXIMIZE_CACHING)" ]
then
	echo "export FIL_PROOFS_MAXIMIZE_CACHING=1" >> $envirConfig
	echo "export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1" >> $envirConfig
fi

source /root/.bashrc
source /etc/profile
echo "-----------------Env configuration finished!!!-----------------"

#3. install dependancy
echo "-----------------Starting dependancy installation-----------------"
mv /etc/apt/sources.list /etc/apt/sources.list.local
cp /home/envshell/sources.list.aliyun /etc/apt/
mv /etc/apt/sources.list.aliyun /etc/apt/sources.list

apt update
apt install -y gcc git bzr jq pkg-config mesa-opencl-icd ocl-icd-opencl-dev ubuntu-drivers-common lrzsz

checkgo=$(go version)
if [ "$checkgo" != "go version go1.15.6 linux/amd64" ]
then
	wget https://gomirrors.org/dl/go/go1.15.6.linux-amd64.tar.gz
	tar -C /usr/local -xzf /home/envshell/go1.15.6.linux-amd64.tar.gz
	echo "export PATH=$PATH:/usr/local/go/bin" >> $envirConfig
	source /root/.bashrc
else
	echo "-----------------go 1.15 already installed!!!-----------------"
fi

mv /etc/apt/sources.list /etc/apt/sources.list.aliyun
mv /home/envshell/sources.list.original /etc/apt/
mv /etc/apt/sources.list.original /etc/apt/sources.list

apt install -y nvidia-driver-440-server ntpdate
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate ntp.aliyun.com
echo "-----------------All finished!!-----------------"

#4.install fininshed, check installation

nonvidia=$(nvidia-smi | grep "NVIDIA")
if [ -n "$nonvidia" ]
then
	echo "-----------------NVIDIA driver successfully installed-----------------"
else
	echo "-----------------NVIDIA driver not installed, please check-----------------"
fi

nogolang=$(go version | grep "go1.15")
if [ -n "$nogolang" ]
then
	echo "-----------------Golang successfully installed-----------------"
else
	echo "-----------------Golang not installed, please check-----------------"
fi

notmounted=$(df -h | grep "/mnt")
if [ -n "$notmounted" ]
then
	echo "-----------------Disks successfully mounted-----------------"
else
	echo "-----------------Disks not mounted, please check-----------------"
fi
