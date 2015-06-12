#!/bin/bash

WEATHER_LOCAL_DATA_FILE=/home/amin/bin/weather/weather_TOTAL.out
WEATHER_TARGET_DATA_FOLDER=/tmp/weather_data
WEATHER_HADOOP_DATA_FOLDER=/data/weather/current/stage
WEATHER_HADOOP_SRC_TABLE=v_weather_current
WEATHER_HADOOP_TGT_TABLE=weather_current_internal
BCK_FOLDER=/mnt/localDisk/DATA_BACKUP/weather
TGT_FILE=`date +"%Y%m%d%H%M%S"`_weather.out
LOGFILE=/home/amin/logs/weather.log

echo -e "check if anything to process - exit otherwise\n"
if [ -e "$WEATHER_LOCAL_DATA_FILE" ];
then 
	if ! [[ "`wc -l $WEATHER_LOCAL_DATA_FILE | awk '{ print $1}'`" -gt "0" ]]; then echo -e "`date` - Fail: no data to process" >> $LOGFILE; exit 1; fi
else echo -e "`date` - Fail: no file to process" >> $LOGFILE; exit 2;
fi

echo -e "1 - copy the file over to master and remove from local dir (or copy to BCK drive)\n"
mv $WEATHER_LOCAL_DATA_FILE $BCK_FOLDER/$TGT_FILE
scp $BCK_FOLDER/$TGT_FILE root@master:$WEATHER_TARGET_DATA_FOLDER/
if ! [[ "$?" -eq "0" ]]; then echo "`date` - Fail: copy to master, file $TGT_FILE" >> $LOGFILE; exit 3; fi

echo -e "2 - upload the file to hadoop folder and remove from target dir\n"
ssh root@master "hadoop fs -put $WEATHER_TARGET_DATA_FOLDER/$TGT_FILE $WEATHER_HADOOP_DATA_FOLDER"
if ! [[ "$?" -eq "0" ]]; then echo "`date` - Fail: copy to hadoop, file $TGT_FILE" >> $LOGFILE; exit 4; fi
ssh root@master "rm -f $WEATHER_TARGET_DATA_FOLDER/$TGT_FILE"

echo -e "3 - copy to WEATHER internal table and remove from hadoop stage folder\n"
ssh root@master "hive -e 'INSERT INTO TABLE $WEATHER_HADOOP_TGT_TABLE select * from $WEATHER_HADOOP_SRC_TABLE;'"
if ! [[ "$?" -eq "0" ]]; then echo "`date` - Fail: copy to internal table, src_table: $WEATHER_HADOOP_SRC_TABLE , tgt_table: $WEATHER_HADOOP_TGT_TABLE" >> $LOGFILE; exit 5; else echo "Success @ `date`" >> $LOGFILE; fi
ssh root@master "hadoop fs -rm -f -skipTrash $WEATHER_HADOOP_DATA_FOLDER/*"

