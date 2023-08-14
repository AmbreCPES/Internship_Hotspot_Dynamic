#!/usr/bin/env bash

while [[ $# -gt 1   ]]
do
	key="$1"

	case $key in
		-p|--param)
			param="$2"
			shift # past argument
			;;
			
		*)
			;;
			# unknown option
	esac
	shift # past argument or value
done

PROJ_SCRIPT=/beegfs/data/ajaeger/Simulation_3/1_Script
script_name="ldhelmet_2"

QUEUE_TIME="03:00:00"


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                          CREATE SBATCH FILES                          ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #



main_output_folder=/home/jaeger/sshfs-path_4/Simulation_3/3_Output_ldhelmet/Param_${param}
if [ ! -d $main_output_folder ] ; then mkdir $main_output_folder ; fi

SBATCH=/home/jaeger/sshfs-path_4/Simulation_3/3_Output_ldhelmet/Param_${param}/sbatch
if [ ! -d $SBATCH ] ; then mkdir $SBATCH ; fi

LOG=/home/jaeger/sshfs-path_4/Simulation_3/3_Output_ldhelmet/Param_${param}/log
if [ ! -d $LOG ] ; then mkdir $LOG ; fi


for ((COUNTER=0; COUNTER<=19; COUNTER++)); do
	SBATCH_file=$SBATCH/${script_name}.${COUNTER}.sbatch
  
	echo "#!/bin/bash" > $SBATCH_file
	echo "#SBATCH --time=$QUEUE_TIME" >> $SBATCH_file
	echo "#SBATCH --cpus-per-task=1" >> $SBATCH_file
	echo "#SBATCH --output=/beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet/Param_${param}/log/$script_name.out.${COUNTER}.out" >> $SBATCH_file
	echo "#SBATCH --error=/beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet/Param_${param}/log/$script_name.err.${COUNTER}.err" >> $SBATCH_file
	echo bash $PROJ_SCRIPT/$script_name.bash -p $param -c $COUNTER  >> $SBATCH_file


done
