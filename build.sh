#!/bin/bash

LOGFILE=build.log

betoffice=( betoffice-parent-pom \
 betoffice-storage_TRUNK \
 betoffice-exchange_TRUNK \
 betoffice-swing_TRUNK )

echo "Start building..."
echo ${#betoffice[@]} 

for index in $(seq 0 $((${#betoffice[@]} - 1)))
do
    project=${betoffice[index]}
    echo "Build project ${project}"
    cd $project
    mvn clean install | tee ${LOGFILE}
    cd ..
done

exit 0
