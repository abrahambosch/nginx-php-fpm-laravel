#!/bin/bash

. .env
DB_FILE="db.sql"
DB_SIZE=$(ls -l $DB_FILE | awk '{print $5}')
docker exec -it db '/usr/bin/pv -pf -i 30 -w 100 -F "%t %b rate:%r avg:%a %p %e" -s $(( ($DB_SIZE + 0) * 1024 )) $DB_FILE | mysql $DB_DATABASE -u $DB_USERNAME -p$DB_PASSWORD '
