#!/bin/bash 
. /shared_data/hdp_manual_install_rpm_helper_files-2.2.4.2.2/scripts/usersAndGroups.sh
. /shared_data/hdp_manual_install_rpm_helper_files-2.2.4.2.2/scripts/directories.sh

sudo mkdir -p $DFS_DATA_DIR;
sudo chown -R $HDFS_USER:$HADOOP_GROUP $DFS_DATA_DIR;
sudo chmod -R 750 $DFS_DATA_DIR;

