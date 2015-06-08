#!/bin/bash 
. /shared_data/hdp_manual_install_rpm_helper_files-2.2.4.2.2/scripts/usersAndGroups.sh
. /shared_data/hdp_manual_install_rpm_helper_files-2.2.4.2.2/scripts/directories.sh

sudo mkdir -p $DFS_NAME_DIR;
sudo chown -R $HDFS_USER:$HADOOP_GROUP $DFS_NAME_DIR;
sudo chmod -R 755 $DFS_NAME_DIR;

sudo mkdir -p $FS_CHECKPOINT_DIR;
sudo chown -R $HDFS_USER:$HADOOP_GROUP $FS_CHECKPOINT_DIR;
sudo chmod -R 755 $FS_CHECKPOINT_DIR;
