#!/bin/bash
: ${HADOOP_PREFIX:=/usr/local/hadoop}
sudo $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid
service ssh start
# $HADOOP_PREFIX/sbin/start-dfs.sh

# Launch bash console  
/bin/bash
