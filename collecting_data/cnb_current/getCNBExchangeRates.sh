#!/bin/sh
# only get the exchange rates if the current day matches the day on the obtained file header
# otherwise dont even gather the info

old_IFS=$IFS           
IFS=$'\n'  

BASE_URL=http://www.cnb.cz/en/financial_markets/foreign_exchange_market/exchange_rate_fixing/daily.txt?date=
#DATE=$1
DATE=`date +"%d.%m.%Y"`
DATE_DESCR=`date +"%d-%b-%Y"`

wget $BASE_URL$DATE -O out.txt
DATE_EXCH=`head -n1 out.txt | sed -e 's/\./-/g' | awk -F' ' '{print $1"-"$2}'`

if [ "$DATE_DESCR" == "$DATE_EXCH" ]; then {
	for line in $(tail -n+3 out.txt)
	do
		echo $DATE_EXCH"|"$line >> dailyExchange.out
	done
	#echo -e "\n" >> dailyExchange.out
	rm out.txt
	}
else {
	rm out.txt 
	IFS=$old_IFS
	exit 1; }
fi

IFS=$old_IFS
