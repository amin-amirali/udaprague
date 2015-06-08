#!/bin/sh

echo -e "\n\n starting deploy at `date` \n\n" >> timer.out
echo -e "----------------------------------\n"
./deploy.sh
echo -e "----------------------------------\n"
echo -e "----------------------------------\n"
echo -e "finished deploy at `date` \n\n" >> timer.out

