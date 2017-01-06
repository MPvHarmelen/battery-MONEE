#!/bin/bash
INPUT_FILES=level*

QUARTILE_BINSIZE=1000
FISHER_BINSIZE=5000

DIR=`readlink -fn $0`
BASEDIR=`dirname $DIR`

# Quartiles
echo "Calculating quartiles"
${BASEDIR}/read_depletionlog.py summary $QUARTILE_BINSIZE $INPUT_FILES -q depletion_time

echo "Calculating Fisher's exact test"
${BASEDIR}/read_depletionlog.py summary $FISHER_BINSIZE $INPUT_FILES -f depletion_time n_pucks distance
