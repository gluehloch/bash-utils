#!/bin/bash

# boprod@tippdiekistebier.de
rsync --delete -avzbe ssh mariadb.tdkb2:~/backup ~/tippdiekistebier

databaseImport() {
    echo "Parameter: filename-prefix=$1, user=$2, password=$3, database=$4"
    echo "----> Start import ..."


    NEWEST_BACKUP_FILE=$(ls -t ~/tippdiekistebier/backup/$1* | head -1)
    IMPORT_FILE=${NEWEST_BACKUP_FILE%.*}

    echo "Start gunzip of $NEWEST_BACKUP_FILE"
    gunzip  "$NEWEST_BACKUP_FILE"

    echo "Import to mysql $NEWEST_BACKUP_FILE%.*"
    # Virtual Box | betoffice development server
    # /bin/mysql -u betofficesu --password=betoffice -D betoffice -h 192.168.0.136 < "$IMPORT_FILE"
    # Docker | betofficedb
    /bin/mysql -f -u $2 --password=$3 -D $4 -h 127.0.0.1 < $IMPORT_FILE

    if [ $? -eq 0 ]
    then
        echo "----> Import successful."
    else
        echo "----> ERROR: $?" 
    fi
}

databaseImport 'betoffice' betofficesu betoffice betoffice
databaseImport 'register' registersu register register
exit 0
