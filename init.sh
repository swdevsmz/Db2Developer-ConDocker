#!/bin/bash

# SELinuxの無効化
setenforce 0

# SELinuxの無効化を永続化
sed -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config > tmp
mv -f tmp /etc/selinux/config
rm -if tmp

# ファイアーウォールを無効化
systemctl stop firewalld
systemctl disable firewalld

# yum-utilsと、devicemapperで必要とされるパッケージをインストール
yum install -y yum-utils  device-mapper-persistent-data  lvm2

# Docker CEをインストールするため、yumのリポジトリを追加します。
yum-config-manager  --add-repo  https://download.docker.com/linux/centos/docker-ce.repo

# docker-ce.repoが追加されていることが確認できます。
#ll /etc/yum.repos.d/

# Docker CEをインストールします。
yum -y install docker-ce

# Dockerサービスを開始します。
systemctl start docker

# Dockerサービスの自動起動設定
systemctl enable docker

# Docker Composeのインストール
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# DockerComposeのバージョン確認
#docker-compose --version

exit 0