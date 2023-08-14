#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                            SCRIPT SUMMARY                             ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

## SCRIPT SUMMARY:
## ~~~~~~~~~~~~~~~
# Running SliM control neg file. Runs control neg 100 times. control neg is the same as Simulation_3 Suimulation.slim with r0 and r set to 0.
#(Ne=25000, L=25000, L_HS=2000, mutation matrix unchanged)
#There is no recombination of any kind for the 14 000 generations. 
#To be run on computer not on cluster.

 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              PARAMETERS                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Default parameters (correspond to 1 set of Parameter)
#all parameters are set in SLiM file, except for loci

	
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              SLiM RUN                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
	

FOLDER=/home/jaeger/sshfs-path_4

LOG=${FOLDER}/Simulation_3/log/Slim/control_neg_3
OUT=${FOLDER}/Simulation_3/2_Data_Slim/Out_Slim
SCRIPT=${FOLDER}/Simulation_3/1_Script/control_neg_3.slim

#Creation of LOG directory
if [ ! -d $LOG ] ; then mkdir $LOG ; fi


for ((ind=109; ind<=200; ind++))
do
loci=$ind
#SLiM run
	if [ ! -d ${OUT}/control_neg/loci_${loci} ]
	then 

	(echo "Run de Slim") > $LOG/loci_${loci}  2>&1

	(slim -d loci=$loci $SCRIPT) >> $LOG/loci_${loci}  2>&1

	fi
done

 
