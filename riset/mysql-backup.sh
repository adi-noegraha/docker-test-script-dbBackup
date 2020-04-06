#!/bin/bash
 
################################################################
##
##   MySQL Database Backup Script 
##   Written By: Rahul Kumar
##   URL: https://tecadmin.net/bash-script-mysql-database-backup/
##   Last Update: Jan 05, 2019
##
################################################################
 
export PATH=/bin:/usr/bin:/usr/local/bin
TODAY=`date +"%d%b%Y"`
TIME=`date +"%T"`
################################################################
################## Update below values  ########################
 
#DB_BACKUP_PATH='/backup/mysql-dbbackup'
DB_BACKUP_PATH='adi-test'
DOCKER_NAME='41b5ee8cfd8a'
#MYSQL_HOST='172.18.0.2'
#MYSQL_PORT='3306'
MYSQL_USER='root'
MYSQL_PASSWORD='example'
DATABASE_NAME='isw'
BACKUP_RETAIN_DAYS=30   ## Number of days to keep local backup copy
 
#################################################################
 
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"

#sudo docker exec -it 41b5ee8cfd8a /usr/bin/mysqldump -u root --password=example isw > isw.sql ##contoh ngambil dr docker
sudo docker exec -it ${DOCKER_NAME} /usr/bin/mysqldump \
-u ${MYSQL_USER} \
--password=${MYSQL_PASSWORD} ${DATABASE_NAME} > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}-${TIME}.sql
#${DATABASE_NAME} | gzip > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}-${TIME}.sql

#mysqldump -h ${MYSQL_HOST} \
#   -P ${MYSQL_PORT} \
#   -u ${MYSQL_USER} \
#   -p${MYSQL_PASSWORD} \
#   ${DATABASE_NAME} | gzip > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz
 
if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi
 
 
##### Remove backups older than {BACKUP_RETAIN_DAYS} days  #####
 
DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`
 
if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi
 
### End of script ####
