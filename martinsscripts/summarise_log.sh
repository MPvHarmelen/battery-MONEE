#!/bin/bash

INPUT_FILES=level*

BINSIZE=1000
ITERATIONS=5000000 #`tail -n 1 level* | awk '{print $1}' | sort -n | tail -n 1`

PUCK_RESULTS=pucks-collected
INSEM_RESULTS=inseminations
DIR=`readlink -fn $0`
BASEDIR=`dirname $DIR`


# temp file for paste results
PASTE_BUFFER=`mktemp`
PUCK_BUFFER=`mktemp`

# Count pucks
echo "Counting pucks"

# Generate timestep column
seq 0 $BINSIZE $ITERATIONS > ${PUCK_RESULTS}
for f in $INPUT_FILES; do
    echo "Processing $f ..."
    cat $f | awk '/PuckTaken/{print $2}' | tr -d '(' | tr -d ')' | awk -F';' -v binsize=${BINSIZE} -v iterations=${ITERATIONS} 'BEGIN{for (i=0; i<=(iterations/binsize); i++){pucks[i,0]=0;pucks[i,1]=0}}{pucks[int($1/binsize),$2]+=1}END{for (i=0; i<=(iterations/binsize); i++) { print  1000*i, pucks[i,0], pucks[i,1]}}' | sort -n -k 1 > ${PUCK_BUFFER}
    awk '{print $2}'  ${PUCK_BUFFER} | paste ${PUCK_RESULTS} - > ${PASTE_BUFFER}
    mv ${PASTE_BUFFER} ${PUCK_RESULTS}
done

# Count inseminations
echo "Counting inseminations"
${BASEDIR}/count_inseminations.py $INSEM_RESULTS $ITERATIONS $BINSIZE $INPUT_FILES


# Summarise
echo "Summarising..."
$BASEDIR/columns_to_quartiles.py -i 1 $INSEM_RESULTS $INSEM_RESULTS.plotdata
$BASEDIR/columns_to_quartiles.py -i 1 $PUCK_RESULTS $PUCK_RESULTS.plotdata

echo Done.
