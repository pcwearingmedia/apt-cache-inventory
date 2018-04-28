#!/bin/bash

	# Script name: APT Cache Inventory
	#
	# Author: P-C Markovski
	# Date (Git repo init): 2018-04-28
	# Purpose:
	#	 Count all repository hits for all characters a-z and 0-9.
	#	 Display hits per search (^i) and a total.
	# ToDo: The speed impact of appending arrays to existing arrays. Notice the totalcache array append operation's speed impact.

unset keys newit totalcache total

keys=({a..z} {0..9})
echo ${keys[@]}

IFS=$'\n'

	# Step through the array with characters and search the apt cache.

for i in ${keys[@]}; do
	echo $i

		# Search the apt cache for elements beginning with character i, store in array.
	newit=($(apt-cache search $i | grep ^$i))

		# Store the current hits in the grand total array with apt cache results.
	totalcache=(${totalcache[@]} ${newit[@]})

		# Count the number of hits for apt cache packages beginning with i.
	newitlen=${#newit[@]}
		# Increment the total hit counter by this iteration's nr.
	((total+=newitlen))

		# Print the current iteration's result count and the total count.
	printf "Current iteration: %s and total is: %s\n" $newitlen $total

		# Lithmus test: Print the last element in the array for this loop iteration. Check that initial character matches.
	#printf "Current highest hit: %s\n" ${newit[-1]}
done


	# ${totalcache[]} now contains all the apt cache hits.
	# We can therefore use this array for any further calculations.

	# Print the calculated total of package hits in the apt cache.
echo $total

	$ Print array with found packages into text file.
printf "%s\n" ${totalcache[@]} > totalcache.txt




