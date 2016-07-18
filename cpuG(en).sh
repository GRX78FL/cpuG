#!/bin/bash 

clear

if [ "$(id -u)" != "0" ]; then
	echo "Higher privileges are needed. "
fi
echo `sudo chmod ugo=rw /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
echo `sudo chmod ugo=rw /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
echo `sudo chmod ugo=rw /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor`
echo `sudo chmod ugo=rw /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor`
clear

sleep 1
echo `cpufreq-info | grep "available governors:" | sed  -e '$!d'`
echo " "
echo " 1 -> Powersave"
echo " 2 -> Conservative"
echo " 3 -> Ondemand"
echo " 4 -> Performance"
echo " 5 -> Userspace"
echo " x -> Exit"
echo " "

read -p "Set governor: " mod

echo " "

if [ "$mod" == "x" ] ; then								
		exit
fi

if [ $mod -eq 1 ] ; then
		echo "Powersave. "
		echo `echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
		echo `echo powersave > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
		echo `echo powersave > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor`
		echo `echo powersave > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor`
else
		if [ $mod -eq 2 ] ; then
				echo "Conservative."
				echo `echo conservative > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
				echo `echo conservative > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
				echo `echo conservative > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor`
				echo `echo conservative > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor`
		else 
				if [ $mod -eq 3 ] ; then 
						echo "Ondemand."
						echo `echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
						echo `echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
						echo `echo ondemand > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor`
						echo `echo ondemand > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor`
				else 
						if [ $mod -eq 4 ] ; then
								echo "Performance."
								echo `echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
								echo `echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
								echo `echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor`
								echo `echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor`								
						else
								if [ $mod -eq 5 ] ; then
										echo `echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
										echo `echo userspace > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor`
										echo `echo userspace > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor`
										echo `echo userspace > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor`
										sleep 1
										clear
										cpufreq-info | grep "available frequencies" | sed  -e '$!d ;s/:/\n/g; s/,/\n/g' &&   sleep 1 
										read -p "Set the max frequency (es: '1.60GHz'): " mxfreq
										sudo cpufreq-set -c 0 -u "$mxfreq"
										sudo cpufreq-set -c 1 -u "$mxfreq"
										sudo cpufreq-set -c 2 -u "$mxfreq"
										sudo cpufreq-set -c 3 -u "$mxfreq"
										read -p "Set the min frequency (es: '1.20GHz'): " mnfreq
										sudo cpufreq-set -c 0 -d "$mnfreq"
										sudo cpufreq-set -c 1 -d "$mnfreq"
										sudo cpufreq-set -c 2 -d "$mnfreq"
										sudo cpufreq-set -c 3 -d "$mnfreq"
								fi
						fi
				fi
		fi
fi
sleep 1
clear 
exit
