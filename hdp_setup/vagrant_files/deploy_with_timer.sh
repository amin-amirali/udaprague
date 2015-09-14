#!/bin/sh

echo -e "Starting deploy at `date`" >> timer.out
echo -e "----------------------------------\n"
./deploy.sh
echo -e "----------------------------------\n"
echo -e "----------------------------------\n"
echo -e "Finished deploy at `date`" >> timer.out

