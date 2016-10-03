#!/bin/bash 

clear
								#check if the user has root privileges
if [ "$EUID" -ne 0 ]; then 
	echo "You have to run this script as root."
	echo "Exiting..."
	sleep 1
	exit
fi
								#Displaying the most common governors
echo -e "Welcome in CpuG! \n"
echo -e "Governors: \n \n 1 -> Powersave \n 2 -> Conservative \n 3 -> Ondemand \n 4 -> Performance \n 5 -> Userspace \n x -> Exit"
echo " "
read -p "Set governor: " mod

n=$(nproc)
n=$(( $n - 1 ))
								#checking if the user wants to exit
if [ $mod == "x" ] ; then								
		exit
fi
					#the loop uses a command (nproc) to know how many cores are installed in the system and manage them all
while [ $n -ge 0 ]
do
	if [ $mod -eq 1 ]; then 
		cpufreq-set -c $n -g powersave
		else
			if [ $mod -eq 2 ]; then
				cpufreq-set -c $n -g conservative
				else
					if [ $mod -eq 3 ] ; then
						cpufreq-set -c $n -g ondemand
						else
							if [ $mod -eq 4 ] ; then
								cpufreq-set -c $n -g performance
								else
									if [ $mod -eq 5 ] ; then
										cpufreq-set -c $n -g userspace 
										read -p "Set the max frequency (es: '1.60GHz'): " mxfreq
										read -p "Set the min frequency (es: '1.20GHz'): " mnfreq
										cpufreq-info | grep "available frequency" | sed  -e '$!d ;s/:/\n/g; s/,/\n/g'
										cpufreq-set -c $n -u "$mxfreq"
										cpufreq-set -c $n -d "$mnfreq"
										else 
											echo "No available options for '$mod' entry, exiting..."
											sleep 1
											exit
									fi
							fi
					fi
			fi
	fi	
	n=$(( $n - 1 ))
done

sleep 1
clear 
exit
