#!/bin/bash
BACKUP_DIR=/backup-database/mysql
DB_NAME=
TSTAMP='date +%Y%m%d'
FILENAME=$BACKUP_DIR/$DB_NAME.gz
Notify=0
Rotate=30
USER=root
PASSWORD=' '
HOST=127.0.0.1
logfile=$BACKUP_DIR/backup.log
echo ".............Backup Script Running on $TSTAMP............" >> $logfile
let i=$Rotate-1

if [ -f "$FILENAME.$Rotate" ];then
  echo "$FILENAME.$Rotate Found,Deleting" >> $logfile
  rm -rf $FILENAME.$Rotate
else
  echo "$FILENAME.$Rotate Not Found, Not Removing" >> $logfile
fi
while [ $i -ge 1 ]
  do
  let j=$i+1;
  if [ -f "$FILENAME.$i" ];then
    echo $FILENAME.$i exists and is being moved to $FILENAME.$j >> $logfile
    mv $FILENAME.$i $FILENAME.$j
  else
    echo $FILENAME.$i not found, not moving to $FILENAME.$j >> $logfile
  fi
  let i=$i-1
done
mysqldump -u $USER -h $HOST -p$PASSWORD $DB_NAME | gzip > $FILENAME.1
echo "..........Backup Script Completed,Exiting Now.$TSTAMP........." >> $logfile
if [ $Notify == 1 ];then
  SUBJECT="Database Backup Completed on:'hostname'"
  ADMIN="admin email"
  function message {
    echo -e "Hi there,\n"
    echo -e "..........................................................\n"
    echo -e "This is to notify that database backup has completed on:'hostname'\n"
    echo -e "Date-Time:'date'\n"
    echo -e "--------------------------------------------------------\n"
  }
fi
