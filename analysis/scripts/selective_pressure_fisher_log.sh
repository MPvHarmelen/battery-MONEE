#!/bin/bash
#
# Calculate Fischer's exact test (FET) for likelihood of offspring vs distance and vs
# nr of pucks selected.
# Test calculated over all runs, per time-slice
# Test requires 2x2 matrix. Classes we use: any offspring or none, above or below median
# distance/puck count for that particular time-slice.
#

BASEDIR=="$( dirname "$0" )"

sliceSize=5000

for experiment in $@
do
	pushd ${experiment}
	(
#		bash $BASEDIR/analyse-pressure.sh
		tempfile=`mktemp FETXXXX`

		# Perform counts for Fischer's exact test
		# expected pressure-stats columns:
		# Time, Id, green puck count, red puck count, distance, offspring
		gawk -f $BASEDIR/fishers_exact_test.awk *.pressure-stats > $tempfile

		rm -f FET.txt

		# Call R's Fisher's exact test for distance-based calcs
		R --no-save --slave <<RSCRIPT
		theTest <- function(x) {
			resultD = fisher.test(matrix(c(x["d_A"],x["d_C"],x["d_B"],x["d_D"]),nrow=2))
			resultP = fisher.test(matrix(c(x["p_A"],x["p_C"],x["p_B"],x["p_D"]),nrow=2))
			cat(paste(x["time"], resultD["p.value"], resultP["p.value"],"\n", sep=" "),
					file="FET.txt", append=TRUE)
		}

		counts = read.table("$tempfile", sep=" ",
			col.names=c("time", "d_A", "d_B", "d_C", "d_D", "p_A", "p_B", "p_C", "p_D"))
		apply(counts, 1, theTest)
RSCRIPT

		rm $tempfile

		gnuplot -e "set term pngcairo; set output 'selective-pressure.png'" /Volumes/Slartibartfast/monee/fisher.gpl
	)&
	popd
done

wait