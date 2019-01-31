#!/usr/bin/env bash

HDP_VERSION="3.2.0"
HDP_HOME="/opt/hadoop-${HDP_VERSION}"

echo "### Installing Hadoop pre-reqs ###"
apt-get update && apt-get upgrade -y
sudo apt-get install -y openjdk-8-jdk ssh rsync

echo "### Creating users and groups ###"
sudo addgroup hadoop
sudo adduser --system --quiet --ingroup hadoop hduser
ssh-keygen -t rsa -f ${HOME}/.ssh/id_rsa -P ""
cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys

echo "### Extracting Hadoop ###"
sudo cp -v /vagrant/hadoop-${HDP_VERSION}.tar.gz /opt
cd /opt
sudo tar -xzvf hadoop-${HDP_VERSION}.tar.gz 

echo "### Copying initial setup files ###"
sudo cp -v /vagrant/etc/* /opt/hadoop-${HDP_VERSION}/etc/hadoop/

echo "### Set profile to export Hadoop vars"
sudo cp -v /vagrant/profile/* /etc/profile.d/
source /etc/profile.d/Z99-hadoop-vars.sh

echo "### Format the NameNode ###"
cd ${HDP_HOME}
bin/hdfs namenode -format

echo "# Starting server (DFS,YARN)"
cd ${HDP_HOME}
nohup sbin/start-dfs.sh
nohup sbin/start-yarn.sh