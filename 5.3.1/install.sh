#!/bin/bash

ssh-keygen -t rsa -P ""

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

xcode-select --install

brew install maven

BASEDIR=`pwd`

mkdir -p /usr/local/cloudera
cd /usr/local/cloudera
CDH="5.3.1"

mkdir -p ${CDH}
mkdir -p ops

cd ops
mkdir -p dn
mkdir -p nn
mkdir -p logs
mkdir -p logs/hadoop
mkdir -p logs/hbase
mkdir -p logs/yarn
mkdir -p pids
mkdir -p tmp
mkdir -p zk

cd /usr/local/cloudera/${CDH}

wget http://archive.cloudera.com/cdh5/cdh/5/flume-ng-1.5.0-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.5.0-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hbase-0.98.6-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hive-0.13.1-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hue-3.7.0-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/oozie-4.0.0-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/pig-0.12.0-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/sqoop-1.4.5-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.3.1.tar.gz
wget http://www.mirrorservice.org/sites/ftp.apache.org/spark/spark-1.4.1/spark-1.4.1.tgz

tar -xvf flume-ng-1.5.0-cdh5.3.1.tar.gz
tar -xvf hadoop-2.5.0-cdh5.3.1.tar.gz
tar -xvf hbase-0.98.6-cdh5.3.1.tar.gz
tar -xvf hive-0.13.1-cdh5.3.1.tar.gz
tar -xvf hue-3.7.0-cdh5.3.1.tar.gz
tar -xvf oozie-4.0.0-cdh5.3.1.tar.gz
tar -xvf pig-0.12.0-cdh5.3.1.tar.gz
tar -xvf spark-1.4.1.tgz
tar -xvf sqoop-1.4.5-cdh5.3.1.tar.gz
tar -xvf zookeeper-3.4.5-cdh5.3.1.tar.gz

rm *.*gz

mv hadoop-* hadoop
mv hbase-* hbase
mv hive-* hive
mv oozie-* oozie
mv zookeeper-* zookeeper
mv pig-* pig
mv hue-* hue
mv spark-* spark
mv sqoop-* sqoop
mv apache-flume-* flume
mv zookeeper-* zookeeper

cd ${BASEDIR}

