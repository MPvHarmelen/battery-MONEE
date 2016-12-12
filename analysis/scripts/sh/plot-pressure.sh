#! /bin/bash
# $Id: plot-pressure.sh 5226 2013-11-21 16:00:21Z evert $

BASEDIR=/Volumes/Slartibartfast/monee/selective-pressure/

sliceSize=5000

for experiment in $@
do
	pushd ${experiment}
	(
#	bash /Volumes/RAID/monee/analyse-pressure.sh

	for slice in `seq  $sliceSize $sliceSize 999000`
	do
		let index=$slice/$sliceSize
		awk -v slice=$slice -v sliceSize=$sliceSize 'slice < $1 && $1 < slice + sliceSize{print $0}' *.pressure-stats | \
		sort -n -k 6 | gnuplot -e "set label 't: $slice' at -15,0 textcolor rgb '#808080'" -e "set output 'slice${index}.png'" ${BASEDIR}/plot-pressure.gnuplot  -

	done

	ffmpeg -y -i slice%d.png -vcodec prores -r 4  ${experiment}.selective-pressure.avi
	)&

	rm slice*.png
	popd
done
