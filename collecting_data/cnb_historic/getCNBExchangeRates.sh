#!/bin/sh
# 1st argument represents request date for exchange rate (dd.mm.yyyy) 
# for example: ./getCNBExchangeRates.sh 01.06.2015

old_IFS=$IFS           
IFS=$'\n'  

BASE_URL=http://www.cnb.cz/en/financial_markets/foreign_exchange_market/exchange_rate_fixing/daily.txt?date=
DATE=$1

wget $BASE_URL$DATE -O out.txt
DATE_EXCH=`head -n1 out.txt | sed -e 's/\./-/g' | awk -F' ' '{print $1"-"$2}'`

for line in $(tail -n+2 out.txt)
do
	echo $DATE_EXCH"|"$line >> exchangeRatesCNB.out
done
rm out.txt

IFS=$old_IFS
