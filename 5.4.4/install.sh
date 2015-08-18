#!/bin/bash

ssh-keygen -t rsa -P ""

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


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
wget http://archive.cloudera.com/cdh5/cdh/5/spark-1.2.0-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/sqoop-1.4.5-cdh5.3.1.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.3.1.tar.gz

tar -xvf flume-ng-1.5.0-cdh5.3.1.tar.gz
tar -xvf hadoop-2.5.0-cdh5.3.1.tar.gz
tar -xvf hbase-0.98.6-cdh5.3.1.tar.gz
tar -xvf hive-0.13.1-cdh5.3.1.tar.gz
tar -xvf hue-3.7.0-cdh5.3.1.tar.gz
tar -xvf oozie-4.0.0-cdh5.3.1.tar.gz
tar -xvf pig-0.12.0-cdh5.3.1.tar.gz
tar -xvf spark-1.2.0-cdh5.3.1.tar.gz
tar -xvf sqoop-1.4.5-cdh5.3.1.tar.gz
tar -xvf zookeeper-3.4.5-cdh5.3.1.tar.gz

rm *.gz

mv hadoop-* hadoop
mv hbase-* hbase
mv hive-* hive
mv oozie-* oozie
mv zookeeper-* zookeeper
mv pig-* pig
mv hue-* hue
mv spark=* spark
mv flume-* flume
mv zookeeper-* zookeeper

export HADOOP_HOME="/usr/local/cloudera/${CDH}/hadoop"
export HBASE_HOME="/usr/local/cloudera/${CDH}/hbase"
export HIVE_HOME="/usr/local/cloudera/${CDH}/hive"
export HCAT_HOME="/usr/local/cloudera/${CDH}/hive/hcatalog"
export HUE_HOME="/usr/local/cloudera/${CDH}/hue"

cp ~/.bash_profile ~/.bash_profile.bak

cat << EOF >> ~/.bash_profile
export HADOOP_HOME="/usr/local/cloudera/${CDH}/hadoop"
export HBASE_HOME="/usr/local/cloudera/${CDH}/hbase"
export HIVE_HOME="/usr/local/cloudera/${CDH}/hive"
export HCAT_HOME="/usr/local/cloudera/${CDH}/hive/hcatalog"
export HUE_HOME="/usr/local/cloudera/${CDH}/hue"
export ZK_HOME="/usr/local/cloudera/${CDH}/zookeeper"
export PATH=${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${ZK_HOME}/bin:${HBASE_HOME}/bin:${HIVE_HOME}/bin:${HCAT_HOME}/bin:${M2_HOME}/bin:${ANT_HOME}/bin:${PATH}
EOF

cp $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh.bak

cat << EOF >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
export HADOOP_LOG_DIR="/usr/local/cloudera/ops/logs/hadoop"
export YARN_LOG_DIR="/usr/local/cloudera/ops/logs/yarn"
export HADOOP_PID_DIR="/usr/local/cloudera/ops/pids"
export YARN_PID_DIR=${HADOOP_PID_DIR}
EOF

cp $HBASE_HOME/conf/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh.bak

cat << EOF >> $HBASE_HOME/conf/hbase-env.sh
export HBASE_LOG_DIR="/usr/local/cloudera/ops/logs/hbase"
export HBASE_PID_DIR="/usr/local/cloudera/ops/pids"
export HBASE_MANAGES_ZK=true
EOF

cd $BASEDIR/conf

cp core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
cp yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
cp hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
cp mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
cp hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

