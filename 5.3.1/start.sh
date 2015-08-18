#!/bin/bash

cd /usr/local/cloudera

$HADOOP_HOME/sbin/start-all.sh
$HBASE_HOME/bin/start-hbase.sh
$HIVE_HOME/bin/hive --service metastore &
$HIVE_HOME/bin/hive --service hiveserver2 &
$HBASE_HOME/bin/hbase thrift start &
