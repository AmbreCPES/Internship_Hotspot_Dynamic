#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                            SCRIPT SUMMARY                             ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

## SCRIPT SUMMARY:
## ~~~~~~~~~~~~~~~
# Prepare SBATCH for SLiM application on different parameters sets. We divide 20000 tasks into 50 jobs of 400 tasks and so generate 50 SBATCH files
# In this simulation, there is no need to change mu,rho, Ne, t, r et r0 

#WARNING: the parameters Start, Duree_HS and Duree_tot must be changed considering the paramet set we want to simulate.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              PARAMETERS                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Get parameters
param="Valeur_par_defaut"

Start=7000
Duree_HS=7000
Duree_tot=14000
while [[ $# -gt 1   ]]
do
	key="$1"

	case $key in
		-p|--param)
			param="$2"
			shift # past argument
			;;
		-c|--COUNT)
			COUNT="$2"
			shift # past argument
			;;
		--Start)
			Start="$2"
			shift # past argument
			;;
		--Duree_HS)
			Duree_HS="$2"
			shift # past argument
			;;
		--Duree_tot)
			Duree_tot="$2"
			shift # past argument
			;;
		*)
			# unknown option
			;;
	esac
	shift # past argument or value
done


# Parameters
PROJ_SCRIPT=/beegfs/data/ajaeger/Simulation_3/1_Script
script_name="run_slim"

QUEUE_TIME="06:00:00"

Ne=25000 

r=$(echo 1e-7)
r_hs=$(echo "$r*25.0" )

L=25000
L_HS=2000
n=20



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                          CREATE SBATCH FILES                          ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #



main_output_folder=/home/jaeger/sshfs-path_2/Simulation_3/2_Data_Slim/Out_Slim/Param_${param}
if [ ! -d $main_output_folder ] ; then mkdir $main_output_folder ; fi

SBATCH=/home/jaeger/sshfs-path_2/Simulation_3/2_Data_Slim/Out_Slim/Param_${param}/sbatch
if [ ! -d $SBATCH ] ; then mkdir $SBATCH ; fi

LOG=/home/jaeger/sshfs-path_2/Simulation_3/2_Data_Slim/Out_Slim/Param_${param}/log
if [ ! -d $LOG ] ; then mkdir $LOG ; fi


for ((COUNTER=0; COUNTER<=$COUNT; COUNTER++)); do
	SBATCH_file=$SBATCH/${script_name}.${COUNTER}.sbatch
  
	echo "#!/bin/bash" > $SBATCH_file
	echo "#SBATCH --time=$QUEUE_TIME" >> $SBATCH_file
	echo "#SBATCH --cpus-per-task=1" >> $SBATCH_file
	echo "#SBATCH --output=/beegfs/data/ajaeger/Simulation_3/2_Data_Slim/Out_Slim/Param_${param}/log/$script_name.out.${COUNTER}.out" >> $SBATCH_file
	echo "#SBATCH --error=/beegfs/data/ajaeger/Simulation_3/2_Data_Slim/Out_Slim/Param_${param}/log/$script_name.err.${COUNTER}.err" >> $SBATCH_file
	echo bash $PROJ_SCRIPT/$script_name.bash -p $param -c $COUNTER --Ne $Ne --L $L --L_HS $L_HS --n $n --Start $Start --Duree_HS $Duree_HS --Duree_tot $Duree_tot >> $SBATCH_file


done
