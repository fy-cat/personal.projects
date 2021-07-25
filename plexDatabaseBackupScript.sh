#!/bin/bash

# Backup a Plex database.
# Author Scott Smereka
# Version 1.0

# Script Tested on:
# Ubuntu 12.04 on 2/2/2014	[ OK ] 

# Check for root permissions
if [[ $EUID -ne 0 ]]; then
  echo -e "${scriptName} requires root privledges.\n"
  echo -e "sudo $0 $*\n"
  exit 1
fi

# Plex Database Location.  The trailing slash is 
# needed and important for rsync.
plexDatabase="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs"



#var for folder name
currentFolder="backup_`date +%m_%d_%Y_%H_%M_%S`"

#create folder for backup packup
sudo mkdir /media/download/plex.user.bk/temp/$currentFolder

# Location to backup the directory to.
backupDirectory="/media/download/plex.user.bk/temp/$currentFolder"

# Log file for script's output named with 
# the script's name, date, and time of execution.
scriptName=$(basename ${0})
log="/srv/logs/${scriptName}_`date +%m_%d_%y_%H_%M_%S`'.log"

# Create Log
echo -e "Staring Backup of Plex Database." > $log 2>&1
echo -e "------------------------------------------------------------\n" >> $log 2>&1

# Stop Plex
echo -e "\n\nStopping Plex Media Server." >> $log 2>&1
echo -e "------------------------------------------------------------\n" >> $log 2>&1
sudo service plexmediaserver stop >> $log 2>&1
#
# Backup database
echo -e "\n\nStarting Backup." >> $log 2>&1
echo -e "------------------------------------------------------------\n" >> $log 2>&1
sudo rsync -av --delete "$plexDatabase" "$backupDirectory" >> $log 2>&1

# Restart Plex
echo -e "\n\nStarting Plex Media Server." >> $log 2>&1
echo -e "------------------------------------------------------------\n" >> $log 2>&1
sudo service plexmediaserver start >> $log 2>&1

#sleep 5

DATE=$(date +%Y_%m_%d_%H_%M_%S)

#tar cvzf /media/download/plex.user.bk/backup$DATE.tar $currentFolder 

tar czfP /media/download/plex.user.bk/tars/backup_$DATE.tar /media/download/plex.user.bk/temp/$currentFolder 


#tar czf /media/download/plex.user.bk/backup_$DATE.tar $currentFolder 

rm -r /media/download/plex.user.bk/temp/$currentFolder

# Done
echo -e "\n\nBackup Complete." >> $log 2>&1
