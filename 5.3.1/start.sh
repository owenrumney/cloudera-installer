#!/bin/bash

cd /usr/local/cloudera

$HADOOP_HOME/sbin/start-all.sh
$HBASE_HOME/bin/start-hbase.sh
$HIVE_HOME/bin/hive --service hiveserver2 &
$HBASE_HOME/bin/hbase thrift start &
$HUE_HOME/build/env/bin/hue runserver &
$SPARK_HOME/sbin/start-all.sh

