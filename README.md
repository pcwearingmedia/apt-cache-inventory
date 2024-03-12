## The Debian APT cache in numbers for a human understanding

43184.
That is the number we will begin with today. This is the number of packages available in the APT package cache, when searching for packages that begin with {a..z} or {0..9}.
Check out the following script to try this yourself.
. apt-cache-inventory.sh
I search the UK APT cache on Sunday 4th May 2018. It will not be the same if we change to the NL APT cache, where the total number of packages will be 42773.
We can quickly change to the NL cache with the following command sed command:
. sed -i s/uk/nl/g /etc/apt/sources.list
If we now run the Bash script again we can see a new total count of packages: 43193. Why the discrepancy? To understand this we need to look at the mirroring mechanism for the APT cache.

How APT cache works on a grand scale
The APT cache is spread out in geographical regions and they are synchronized with the master archive at ftp-master.debian.org. This is maintained by the FTP Master team and their tasks include maintaining the infrastructure including the scripts that process uploaded packages. It's important to note that the FTP Master team does not manage which packages goes into unstable or testing,, this is handled by the Release Managers.
Behind the scenes it is possible for the FTP Master team to step in and manually alter the priority of binary packages. Also, plenty of packages get removed, maybe because the source package does not successfully build the binary package, or because of requests from package maintainers to remove packages.
In general, it's wise to mirror the local APT cache from the nearest available APT cache. If you live in the UK, the UK APT cache is a logical choice if you want to minimize the latency. This makes perfect sense but to understand how mirroring takes place, we need to look at the public list of Debian APT mirrors. These mirror archives are primary and secondary. A primary mirror has a) good bandwidth and is b) synching directly from Debian's internal syncproxy network. Finally, c) a primary mirror will usually cover all architectures. Secondary mirrors are therefore not meeting one or more of these criteria, and can therefore offer a limited set of software packages at a lower speed. Not the best solution for an enterprise release management strategy.

Mirroring mechanics
To continue our exploration of apt cache mirrors, we note that a mirror is synchronized with an archive higher up in the tree hierarchy of apt mirrors. The data storage is either using a tarball or a git repository and published via HTTP.
The topmost archive (the master) is updated four times daily, and the mirrors usually begin updating at 03:00, 09:00, 15:00, and 21:00 (UTC). It's a big archive.. When writing this article, the total size is +2700 GB, all architectures, binaries and source included.
The takeaway here is that every mirror only has one upstream which data is synchronized from.

https://www.debian.org/mirror/ftpmirror
If we take a quick look at the sources.list file in /etc/apt, we can see that the URLs are also unencrypted hypertext data.

Push-triggered mirroring for faster updates of mirrors
It's possible to speed up the synchronization “down the chain” of mirror archives using a push triggered mechanism. An upstream mirror will then use a SSH trigger to notify its downstream mirror to update itself. Recall the policy for downstream mirrors to update their archive four times per day. With push-triggered mirroring we can decrease the amount of time a mirror is not up-to-date.
The push mirror uses ssh to login to the pushed mirror's account, public key authentication is used. The key is configured restrictively so that the only possible operation is to trigger a mirror run. The pushed mirror will run ftpsync to update the archive with rsync just like when a normal scheduled update is triggered. (https://www.debian.org/mirror/push_mirroring)

Secondary mirror faster than primary? Yes, could be..
A secondary mirror can have restrictions on what is stored. However, this could also mean that a secondary mirror is faster than a primary mirror. Consider a secondary mirror that is located closer to you geographically and has a smaller archive size than a primary mirror. The secondary is then much faster to search. This could be an important option for a company that wants to have a secure and reliable APT archive that is a subset of the master archive. With the possibility to select the geographical location you are then also more in control of the latencies for searching and downloading from the mirror. Taken together, a partial mirror that is placed close to all your downstream clients can greatly increase download times. There is also the aspect of full release management control when you own a partial mirror.

The public list of APT cache mirrors : https://www.debian.org/mirror/list

So what are people installing?
The Debian project has statistics that show which packages are installed more frequently. We take a quick glance at the statistics to see which top 300 packages are installed. Bear in mind that this relies on statistics gathered from users that have the popularity-contest package installed.
https://popcon.debian.org/by_vote
There you can see the top results.
