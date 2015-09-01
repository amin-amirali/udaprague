#!/bin/sh

echo -e "Starting deploy at `date`\n" >> timer.out
echo -e "----------------------------------\n"
./deploy.sh
echo -e "----------------------------------\n"
echo -e "----------------------------------\n"
echo -e "finished deploy at `date`\n" >> timer.out

