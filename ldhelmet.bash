#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                            SCRIPT SUMMARY                             ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

## SCRIPT SUMMARY:
## ~~~~~~~~~~~~~~~
# Running ldhelmet, to be run on computer not on cluster

 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              PARAMETERS                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


param="default_value"
Ne=25000.0 

mu=$(echo "scale=10;1.25*10^-8"|bc) #Default parameters corresponds to humqn estimate of human mutation and recombinateion rate
#mu initialize in SLiM by mutation matrix, this mu is an estimate of the average rate, same as the one used in MS
r=$(echo "scale=10;1.0*10^-7"|bc)

rhos="0.0 0.1 10.0 1.0 100.0"

IN=/beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet
OUT=/beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet
folder=Simulation_3

b=50.0
pade=FALSE
burn_in=100000
n=1000000

while [[ $# -gt 1   ]]
do
	key="$1"

	case $key in
		
		--Ne)
			Ne="$2"
			shift # past argument
			;;
			
		--mu)
			mu="$2"
			shift # past argument
			;;
			
		--rhos)
			rhos="$2"
			shift # past argument
			;;
		--IN)
			IN="$2"
			shift # past argument
			;;
		--OUT)
			OUT="$2"
			shift # past argument
			;;
		--folder)
			folder="$2"
			shift # past argument
			;;
		--b)
			b="$2"
			shift # past argument
			;;
		*)
			;;
			# unknown option
	esac
	shift # past argument or value
done




theta=$(echo "4.0*$Ne*$mu" | bc)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              SLiM RUN                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


#find_confs
if [ ! -d /beegfs/data/ajaeger/Simulation_3/log/ldhelmet ]
then mkdir /beegfs/data/ajaeger/Simulation_3/log/ldhelmet
fi
LOG=/beegfs/data/ajaeger/Simulation_3/log/ldhelmet/find_confs.log

(echo "Run de find_confs") > $LOG  2>&1 
(time(ldhelmet find_confs --num_threads 2 -w 50 -o ${OUT}/output.conf ${IN}/concatenateFasta_tot)) >> $LOG  2>&1 


#table_gen
LOG=/beegfs/data/ajaeger/Simulation_3/log/ldhelmet/table_gen.log
(echo "Run de table_gen") > $LOG  2>&1 
(time(ldhelmet table_gen --num_threads 2 -c ${OUT}/output.conf -t $theta -r ${rhos} -o ${OUT}/output.lk)) >> $LOG  2>&1 


#OPTIONAL: pade coefficient, not calculated cause lack of time
LOG=/beegfs/data/ajaeger/Simulation_3/log/ldhelmet/pade_${param}.log 
(echo "Run de pade") > $LOG  2>&1
(time(ldhelmet pade --num_threads 2 -c ${OUT}/output.conf -t $theta -x 11 -o ${OUT}/output.pade)) > $LOG  2>&1 
