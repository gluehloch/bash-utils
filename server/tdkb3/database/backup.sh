#!/bin/bash

CURRENTTIME=`date '+%Y-%m-%d-%H%M%S'`

BACKUP_DIR="/home/mariadb/backup"

BETOFFICE_FILENAME="$BACKUP_DIR/betoffice-$CURRENTTIME.sql"
REGISTER_FILENAME="$BACKUP_DIR/register-$CURRENTTIME.sql"

mysqldump -c betoffice -u betofficesu --password=<password> -h 127.0.0.1 > $BETOFFICE_FILENAME
gzip $BETOFFICE_FILENAME

mysqldump -c register -u registersu --password=<password> -h 127.0.0.1 > $REGISTER_FILENAME
gzip $REGISTER_FILENAME

exit 0;

