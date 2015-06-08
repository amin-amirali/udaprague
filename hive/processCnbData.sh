#!/bin/bash

CNB_LOCAL_DATA_FILE=/home/amin/bin/CNB_exchange/dailyExchange.out
CNB_TARGET_DATA_FOLDER=/tmp/cnb_data
CNB_HADOOP_DATA_FOLDER=/data/cnb/stage
CNB_HADOOP_TGT_TABLE=cnb_data_internal
BCK_FOLDER=/mnt/localDisk/DATA_BACKUP/cnb
TGT_FILE=`date +"%Y%m%d%H%M%S"`_dailyExchange.out

echo -e "check if anything to process - exit otherwise\n"
if [ -e "$CNB_LOCAL_DATA_FILE" ];
then 
	if ! [[ "`wc -l $CNB_LOCAL_DATA_FILE | awk '{ print $1}'`" -gt "0" ]]; then echo -e "Fail: no data to process" >> logfile; exit 1; fi
else echo -e "Fail: no file to process" >> logfile; exit 2;
fi


echo -e "1 - copy the file over to master and remove from local dir (or copy to BCK drive)\n"
mv $CNB_LOCAL_DATA_FILE $BCK_FOLDER/$TGT_FILE
scp $BCK_FOLDER/$TGT_FILE root@master:$CNB_TARGET_DATA_FOLDER/
if ! [[ "$?" -eq "0" ]]; then echo "Fail: copy to master" >> logfile; exit 3; fi

echo -e "2 - upload the file to hadoop folder and remove from target dir\n"
ssh root@master "hadoop fs -put $CNB_TARGET_DATA_FOLDER/$TGT_FILE $CNB_HADOOP_DATA_FOLDER"
if ! [[ "$?" -eq "0" ]]; then echo "Fail: copy to hadoop" >> logfile; exit 4; fi
ssh root@master "rm -f $CNB_TARGET_DATA_FOLDER/$TGT_FILE"

echo -e "3 - copy to CNB internal table and remove from hadoop\n"
ssh root@master "hive -e 'INSERT INTO TABLE $CNB_HADOOP_TGT_TABLE select * from cnb_data;'"
if ! [[ "$?" -eq "0" ]]; then echo "Fail: copy to internal table" >> logfile; exit 5; else echo "Success @ `date`" >> logfile; fi
ssh root@master "hadoop fs -rm -f -skipTrash $CNB_HADOOP_DATA_FOLDER/*"

