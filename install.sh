#!/bin/bash

ssh-keygen -t rsa -P ""

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys


BASEDIR=`pwd`

mkdir -p /usr/local/cloudera
cd /usr/local/cloudera

mkdir -p 5.4.4
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

cd /usr/local/cloudera/5.4.4

wget http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hbase-1.0.0-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hive-1.1.0-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/oozie-4.1.0-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/pig-0.12.0-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/hue-3.7.0-cdh5.4.4.tar.gz
wget http://archive.cloudera.com/cdh5/cdh/5/oozie-4.1.0-cdh5.4.4.tar.gz

tar -xvf hadoop-2.6.0-cdh5.4.4.tar.gz
tar -xvf hbase-1.0.0-cdh5.4.4.tar.gz
tar -xvf hive-1.1.0-cdh5.4.4.tar.gz
tar -xvf oozie-4.1.0-cdh5.4.4.tar.gz
tar -xvf zookeeper-3.4.5-cdh5.4.4.tar.gz
tar -xvf pig-0.12.0-cdh5.4.4.tar.gz
tar -xvf hue-3.7.0-cdh5.4.4.tar.gz
tar -xvf oozie-4.1.0-cdh5.4.4.tar.gz

rm *.gz

mv hadoop-2.6.0-cdh5.4.4 hadoop
mv hbase-1.0.0-cdh5.4.4 hbase
mv hive-1.1.0-cdh5.4.4 hive
mv oozie-4.1.0-cdh5.4.4 oozie
mv zookeeper-3.4.5-cdh5.4.4 zookeeper
mv pig-0.12.0-cdh5.4.4 pig
mv hue-3.7.0-cdh5.4.4 hue
mv oozie-4.1.0-cdh5.4.4 oozie

CDH="5.4.4"
export HADOOP_HOME="/usr/local/cloudera/${CDH}/hadoop"
export HBASE_HOME="/usr/local/cloudera/${CDH}/hbase"
export HIVE_HOME="/usr/local/cloudera/${CDH}/hive"
export HCAT_HOME="/usr/local/cloudera/${CDH}/hive/hcatalog"

cp ~/.bash_profile ~/.bash_profile.bak

cat << EOF >> ~/.bash_profile
CDH="5.4.4"
export HADOOP_HOME="/usr/local/cloudera/${CDH}/hadoop"
export HUE_HOME="/usr/local/cloudera/${CDH}/hue"
export HBASE_HOME="/usr/local/cloudera/${CDH}/hbase"
export HIVE_HOME="/usr/local/cloudera/${CDH}/hive"
export HCAT_HOME="/usr/local/cloudera/${CDH}/hive/hcatalog"
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

#configure hue - you'll need brew for this.
brew install gmp
cd hue
make apps

cd $BASEDIR/conf

cp core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
cp yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
cp hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
cp mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
cp hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

hdfs namenode -format
$HADOOP_HOME/sbin/start-all.sh
$HBASE_HOME/bin/start-hbase.sh
$HIVE_HOME/bin/hive service hiveserver
$HUE_HOME/build/env/bin/hue runserver

