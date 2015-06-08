#!/bin/bash 
. /shared_data/hdp_manual_install_rpm_helper_files-2.2.4.2.2/scripts/usersAndGroups.sh 
. /shared_data/hdp_manual_install_rpm_helper_files-2.2.4.2.2/scripts/directories.sh 

sudo mkdir -p $YARN_LOCAL_DIR;
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_DIR;
sudo chmod -R 755 $YARN_LOCAL_DIR;

sudo mkdir -p $YARN_LOCAL_LOG_DIR;
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOCAL_LOG_DIR; 
sudo chmod -R 755 $YARN_LOCAL_LOG_DIR;

sudo mkdir -p $HDFS_LOG_DIR;
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_LOG_DIR;
sudo chmod -R 755 $HDFS_LOG_DIR;

sudo mkdir -p $YARN_LOG_DIR; 
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_LOG_DIR;
sudo chmod -R 755 $YARN_LOG_DIR;

sudo mkdir -p $HDFS_PID_DIR;
sudo chown -R $HDFS_USER:$HADOOP_GROUP $HDFS_PID_DIR;
sudo chmod -R 755 $HDFS_PID_DIR;

sudo mkdir -p $YARN_PID_DIR;
sudo chown -R $YARN_USER:$HADOOP_GROUP $YARN_PID_DIR;
sudo chmod -R 755 $YARN_PID_DIR;
 
sudo mkdir -p $MAPRED_LOG_DIR;
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_LOG_DIR;
sudo chmod -R 755 $MAPRED_LOG_DIR;

sudo mkdir -p $MAPRED_PID_DIR;
sudo chown -R $MAPRED_USER:$HADOOP_GROUP $MAPRED_PID_DIR;
sudo chmod -R 755 $MAPRED_PID_DIR;


