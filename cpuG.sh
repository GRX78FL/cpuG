#!/bin/bash
#
#The reason behind me scripting this is the same
#for every script ever made: lazyness.
#
#So i'd rather pass few hours writing this than
#write the single commands every time i need to
#limit my CPU clock speeds and policies.
#Happy Hacking, I guess.
#
#Scripted by AgentBlade a.k.a. GRX78FL
#
# https://github.com/AgentBlade
# https://dev.parrotsec.org/GRX78FL
#
# This script is free software as defined by
# the GNU General Public License v3 or higher.
#
# For more details about the licencing please
# visit https://www.gnu.org/licenses/gpl.html
#            

function check_permissions {

    if [[ $EUID -ne 0 ]] ; then
	echo -en "[✗] This script is meant to run as root.\n" #check user's permisssion; just a formality
	exit 1                                            #Unix DAC is the real deal here.
    fi
}

function init {
    
    option=0                          
    n=$(( $(nproc) -1 ))           #declaring some essential variables, we don't want to
    mod=0                          #regex the frick out of everything, do we? ( ͡☉ ͜ʖ ͡☉) 
    
    echo -en "\n[!] Welcome in cpuG!\n\n"
    governors_list=$(</sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors) #define where the information is taken from
    clocks_list=$(cpufreq-info | grep "available frequency" |
		      sed  -e '$!d ;s/:/\n/g; s/[available frequency steps| /n]//g; s/,/\n/g'| 
		      awk '!seen[$0]++') #grep: look for the clock_steps #sed: cleaning the output #awk: deleting duplicates
}

function list_options {

    echo -en "[i] Here's a list of governors your CPU supports:\n\n" 
    for available_governor in $governors_list ; do
	echo "[i] Hit "$option" for "$available_governor 
	echo $available_governor >> /tmp/governors.cpuG
	option=$(($option + 1))
    done
    echo -en "\n"
}

function chose_governor {
    
    chose_clock_speeds                       #not very elegant, i know but ¯\_(ツ)_/¯
    list_options
    
    read -sn 1 governor                      #asking for user interaction
    
    case $governor in                        #choose a number between 0 and 5 (no need to abstract the number of options, since
	0)                                   #there are only 6 governor modules in linux) that it can be associated with the same
	    while (( $n >= 0 ))              #line in /tmp/governors.cpuG and as long as there are cores to which change the
	    do                               #policy to we keep going on
		echo -en "[✓]Intructing core #"$n"\n"
		cpufreq-set -c $n -g $(sed -n $(( $(echo "$governor") +1 ))p /tmp/governors.cpuG)
		cpufreq-set -c $n -u "$max_freq" -d "$min_freq"
		n=$(( $n -1 ))
		sleep 0.5
	    done
	    echo -en "\n[✓] Done.\n"
	    ;;
	1)	   
	    while (( $n >= 0 ))
	    do
		echo -en "[✓] Intructing core #"$n"\n"
		cpufreq-set -c $n -g $(sed -n $(( $(echo "$governor") +1 ))p /tmp/governors.cpuG)
		cpufreq-set -c $n -u "$max_freq" -d "$min_freq"
		n=$(( $n -1 ))
		sleep 0.5
	    done
	    echo -en "\n[✓] Done.\n"
	    ;;
	2)
	    while (( $n >= 0 ))
	    do
		echo -en "[✓] Intructing core #"$n"\n"
		cpufreq-set -c $n -g $(sed -n $(( $(echo "$governor") +1 ))p /tmp/governors.cpuG)
		cpufreq-set -c $n -u "$max_freq" -d "$min_freq"
		n=$(( $n -1 ))
		sleep 0.5
	    done
	    echo -en "\n[✓] Done.\n"
	    ;;
	3)
	    while (( $n >= 0 ))
	    do
		echo -en "[✓] Intructing core #"$n"\n"
		cpufreq-set -c $n -g $(sed -n $(( $(echo "$governor") +1 ))p /tmp/governors.cpuG)
		cpufreq-set -c $n -u "$max_freq" -d "$min_freq"
		n=$(( $n -1 ))
		sleep 0.5
	    done
	    echo -en "\n[✓] Done.\n"
	    ;;
	4)
	    while (( $n >= 0 ))
	    do
		echo -en "[✓] Intructing core #"$n"\n"
		cpufreq-set -c $n -g $(sed -n $(( $(echo "$governor") +1 ))p /tmp/governors.cpuG)
		cpufreq-set -c $n -u "$max_freq" -d "$min_freq"
		n=$(( $n -1 ))
		sleep 0.5
	    done
	    echo -en "\n[✓] Done.\n"
	    ;;
	5)
	    while (( $n >= 0 ))
	    do
		echo -en "[✓] Intructing core #"$n"\n"
		cpufreq-set -c $n -g $(sed -n $(( $(echo "$governor") + 1 ))p /tmp/governors.cpuG)
		cpufreq-set -c $n -u "$max_freq" -d "$min_freq"
		n=$(( $n -1 ))
		sleep 0.5
	    done
	    echo -en "\n[✓] Done.\n"
            ;;
	*)
	    echo -en "[✗] You had one job...Typo?\n"
	    rm -rf /tmp/frequencies.cpuG
	    rm -rf /tmp/governors.cpuG
	    exit 1
    esac
}

function chose_clock_speeds {

    echo -en "\n[!] Here's a list of the available clock-steps: \n\n"   #a similar approach to the choice of the governor to use
    for frequency in $clocks_list ; do                              #of the governor but since we don't have any fixed quantity
	echo "[i] Hit "$mod" for " $frequency                          #of scaling_steps we might want to ( ͡☉ ͜ʖ ͡☉)
	echo $frequency >> /tmp/frequencies.cpuG
	mod=$(($mod+1))
    done
    echo -en "\n[_] Set the maximum clock speed: "
    read -sn $(echo -ne $(($mod -1 )) | wc -c) max_freq_line         #check how many digits the user is allowed to enter
    echo -en "\n[_] Set the minimum clock speed: "
    read -sn $(echo -ne $(($mod -1 )) | wc -c) min_freq_line         #and ask for the location of the max and min values
    echo -en "\n"
    max_freq=$( sed -n $(( $(echo "$max_freq_line") + 1 ))p /tmp/frequencies.cpuG)    #read like and assign min and 
    min_freq=$( sed -n $(( $(echo "$min_freq_line") + 1 ))p /tmp/frequencies.cpuG)    #max values accordingly 
}

check_permissions
init
chose_governor

rm -rf /tmp/governors.cpuG
rm -rf /tmp/frequencies.cpuG
