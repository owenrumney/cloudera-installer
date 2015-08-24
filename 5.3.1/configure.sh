#!/bin/bash

BASEDIR=`pwd`
CDH="5.3.1"

export HADOOP_HOME=/usr/local/cloudera/${CDH}/hadoop
export HBASE_HOME=/usr/local/cloudera/${CDH}/hbase
export HIVE_HOME=/usr/local/cloudera/${CDH}/hive
export HCAT_HOME=/usr/local/cloudera/${CDH}/hive/hcatalog
export HUE_HOME=/usr/local/cloudera/${CDH}/hue
export SPARK_HOME=/usr/local/cloudera/${CDH}/spark

cp ~/.bash_profile ~/.bash_profile.bak

cat << EOF >> ~/.bash_profile
export HADOOP_HOME=/usr/local/cloudera/${CDH}/hadoop
export HBASE_HOME=/usr/local/cloudera/${CDH}/hbase
export HIVE_HOME=/usr/local/cloudera/${CDH}/hive
export HCAT_HOME=/usr/local/cloudera/${CDH}/hive/hcatalog
export HUE_HOME=/usr/local/cloudera/${CDH}/hue
export ZK_HOME=/usr/local/cloudera/${CDH}/zookeeper
export SPARK_HOME=/usr/local/cloudera/${CDH}/spark

export PATH=${JAVA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${ZK_HOME}/bin:${HBASE_HOME}/bin:${HIVE_HOME}/bin:${HCAT_HOME}/bin:${M2_HOME}/bin:${ANT_HOME}/bin:${SPARK_HOME}/bin:${PATH}
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
export JAVA_HOME="$(/usr/libexec/java_home -v 1.7)"
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

cd $HUE_HOME
make apps

hdfs namenode -format

cd $SPARK_HOME
./make_distribution.sh



