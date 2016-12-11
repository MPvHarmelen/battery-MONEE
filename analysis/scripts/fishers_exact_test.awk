#!/opt/local/bin/gawk
#
# $Id: $
#
# Output for R's Fischer Exact Test as follows:
#
# 				High Offspring	Low Offspring
# Hi Distance	A 				B
# Low Distance	C 				D
#
# Matrix per time slice
# Analogously for Puck Count
#
# Output: time A B C D A B C D
#              ^^^^^^^ ^^^^^^^
#               dist.   pucks
#

BEGIN {
	binSize = 5000;
	maxIteration = 1000000;
	offspringCutoff = 1;
}

{
	# appropriate time slice
	i = int($1/binSize)

	sizes[i]++
	Ids[i][sizes[i]] = $2
	offspring[i][sizes[i]] = $6;
	distances[i][sizes[i]] = $5;
	puckCounts[i][sizes[i]] = $3 + $4;
}
# Note: 0-based basic arrays, but subarrays 1-based (for asort compatibility)

END {
	# calculate median values per time slice and fill matrices for FET
	for (i=0; i < maxIteration/binSize; i++) {

		n = sizes[i];



		if (!(i in distances)) continue

		# Calculate threshold values
    	asort(distances[i], dist);
    	asort(puckCounts[i], pucks);
    	asort(offspring[i], children);

		percentile = 2  # 2: median, 4: quartile, etc.
		tIndex = int(n/percentile) + 1;
 		thresholdDistance = (n % percentile) ? dist[tIndex] : (dist[tIndex] + dist[tIndex-1])/2;
 		thresholdPuckCount = (n % percentile) ? pucks[tIndex] : (pucks[tIndex] + pucks[tIndex-1])/2;
 		# offspringCutoff = (n % percentile) ? children[tIndex] : (children[tIndex] + pucks[tIndex-1])/2;

 #		print i*binSize, thresholdDistance, thresholdPuckCount > "/dev/stderr"

		dist_a[i] = 0;
		dist_b[i] = 0;
		dist_c[i] = 0;
		dist_d[i] = 0;
		puck_a[i] = 0;
		puck_b[i] = 0;
		puck_c[i] = 0;
		puck_d[i] = 0;

		for (j=1; j<=n; j++)
		{
#			print Ids[i][j], offspring[i][j], distances[i][j], puckCounts[i][j] > "/dev/stderr"
			if (offspring[i][j] < offspringCutoff)  # Low offspring
			{
				if (distances[i][j] < thresholdDistance)
					dist_a[i]++;	# low distance, low offspring
				else
					dist_c[i]++;	# high distance, low offspring

				if (puckCounts[i][j] < thresholdPuckCount)
					puck_a[i]++;	# low pucks, low offspring
				else
					puck_c[i]++;	# high pucks, low offspring
			} else {	# High offspring
				if (distances[i][j] < thresholdDistance)
					dist_b[i]++;	# low distance, high offspring
				else
					dist_d[i]++;	# high distance, high offspring

				if (puckCounts[i][j] < thresholdPuckCount)
					puck_b[i]++;	# low pucks, high offspring
				else
					puck_d[i]++;	# high pucks, high offspring
			}
		}

		print i*binSize, dist_a[i], dist_b[i], dist_c[i], dist_d[i],
						 puck_a[i], puck_b[i], puck_c[i], puck_d[i]
	}
}