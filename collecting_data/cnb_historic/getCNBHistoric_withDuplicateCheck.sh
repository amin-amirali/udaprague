#!/bin/bash

now=`date +"%Y-%m-%d" -d "01/01/2015"`
end=`date +"%Y-%m-%d" -d "06/01/2015"`
 
while [ "$now" != "$end" ] ; 
do 
        ./getCNBExchangeRates.sh `date +"%d.%m.%Y" -d "$now"`
        now=`date +"%Y-%m-%d" -d "$now + 1 day"`; 
done

## perform deduplication of records
sort -t"-" -k1.8,1.11 -k1.4,1.6M -k1.1,1.2 exchangeRatesCNB.out | uniq > exchangeRatesDedupped.out

