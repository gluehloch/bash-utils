#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Missing directory parameter!"
    exit 1
fi

echo "Searching in $1"

### 
### de.gluehloch.groovy.oracle => de.awtools.grooocle
###

find $1 -type f -name "*.java" | while read fn;
do
  echo ${fn}
  
  cp ${fn} ${fn}.bak
  sed -e 's/groovy\-oracle/grooocle/g' ${fn}.bak > ${fn}
  rm ${fn}.bak

done
