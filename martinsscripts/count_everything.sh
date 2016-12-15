#!/bin/bash

BINSIZE=1000
ITERATIONS=1000000 #`tail -n 1 level* | awk '{print $1}' | sort -n | tail -n 1`

PUCK_RESULTS=pucks-collected
INSEM_RESULTS=inseminations
DIR=`readlink -fn $0`
BASEDIR=`dirname $DIR`

# Count inseminations
echo "Counting inseminations"
${BASEDIR}/count_inseminations.py $INSEM_RESULTS $ITERATIONS $BINSIZE level*

# Generate timestep column 
seq 0 $BINSIZE $ITERATIONS > ${PUCK_RESULTS}

#temp file for paste results
PASTE_BUFFER=`mktemp`
PUCK_BUFFER=`mktemp`

# Count pucks
echo "Counting pucks"
for f in level*
do
    echo "Processing $f ..."
    cat $f | awk '/PuckTaken/{print $2}' | tr -d '(' | tr -d ')' | awk -F';' -v binsize=${BINSIZE} -v iterations=${ITERATIONS} 'BEGIN{for (i=0; i<=(iterations/binsize); i++){pucks[i,0]=0;pucks[i,1]=0}}{pucks[int($1/binsize),$2]+=1}END{for (i=0; i<=(iterations/binsize); i++) { print  1000*i, pucks[i,0], pucks[i,1]}}' | sort -n -k 1 > ${PUCK_BUFFER}
    awk '{print $2}'  ${PUCK_BUFFER} | paste ${PUCK_RESULTS} - > ${PASTE_BUFFER}
    mv ${PASTE_BUFFER} ${PUCK_RESULTS}
done

echo "Summarising..."

# Summarise
awk -f ${BASEDIR}/moments-per-line.awk $PUCK_RESULTS > ${PUCK_RESULTS}.stats
awk -f ${BASEDIR}/moments-per-line.awk $INSEM_RESULTS > ${INSEM_RESULTS}.stats


cut -d' ' -f "1 3" ${PUCK_RESULTS}.stats > ${PUCK_RESULTS}.plotdata
cut -d' ' -f "1 3" ${INSEM_RESULTS}.stats > ${INSEM_RESULTS}.plotdata

# # Calculate and summarise puck ratios
# # NOTE: assumes 64 runs!
# paste ${PUCK_RESULTS} ${PUCK_RESULTS}.1 > ${PUCK_RESULTS}

# awk '{printf("%d ", $1); for (i=2; i <= 65; i++){ tot = $i + $(i+65); printf("%f ",  tot==0?0:$i/tot)} print ""}' ${PUCK_RESULTS} > ${PUCK_RESULTS}-ratio.0
# awk '{printf("%d ", $1); for (i=2; i <= 65; i++){ tot = $i + $(i+65); printf("%f ",  tot==0?0:$(i+65)/tot)} print ""}' ${PUCK_RESULTS} > ${PUCK_RESULTS}-ratio.1
# awk -f ${BASEDIR}/moments-per-line.awk $PUCK_RESULTS-ratio.0 > ${PUCK_RESULTS}-ratio.0.stats
# awk -f ${BASEDIR}/moments-per-line.awk $PUCK_RESULTS-ratio.1 > ${PUCK_RESULTS}-ratio.1.stats

# awk '{printf("%d ", $1); for (i=2; i <= 65; i++){ tot = $i + $(i+65); printf("%f ",  tot)} print ""}' ${PUCK_RESULTS} > ${PUCK_RESULTS}.counts
# awk -f ${BASEDIR}/moments-per-line.awk ${PUCK_RESULTS}.counts > ${PUCK_RESULTS}.counts.stats

echo Done.
