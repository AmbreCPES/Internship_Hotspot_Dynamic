#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                            SCRIPT SUMMARY                             ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

## SCRIPT SUMMARY:
## ~~~~~~~~~~~~~~~
# Running SliM Simulation file, to be run on computer not on cluster

 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              PARAMETERS                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# Default parameters (correspond to 1 set of Parameter)

param=1

Ne=25000 
Start=7000
Duree_HS=7000
Duree_tot=14000

#mu initialize in SLiM by mutation matrix

r=$(echo 1e-7)
r_hs=$(echo "$r*25.0" )

while [[ $# -gt 1   ]]
do
	key="$1"

	case $key in
		-p|--param)
			param="$2"
			shift # past argument
			;;
		-c|--COUNTER)
			COUNTER="$2"
			shift # past argument
			;;

		--Ne)
			Ne="$2"
			shift # past argument
			;;
		--L)
			L="$2"
			shift # past argument
			;;
		
		--L_HS)
			L_HS="$2"
			shift # past argument
			;;	
				
		--n)
			n="$2"
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


	
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              SLiM RUN                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
	
#Création fichier log 
LOG=/beegfs/data/ajaeger/Simulation_3/log/Slim/Param_${param}
OUT=/beegfs/data/ajaeger/Simulation_3/2_Data_Slim/Out_Slim
SCRIPT=/beegfs/data/ajaeger/Simulation_3/1_Script/Simulation.slim

if [ ! -d $LOG ] ; then mkdir $LOG ; fi


for ((ind=1; ind<=100; ind++))
do
loci=$(echo "$ind+($COUNTER*100)" | bc)
#Lancement de SLiM
	if [ ! -d ${OUT}/Param_${param}/loci_${loci} ]
	then 

	(echo "Run de Slim") > $LOG/loci_${loci}  2>&1

	(slim -d loci=$loci -d L=$L -d L_HS=$L_HS -d n=$n -d Param=$param -d Ne=$Ne -d r0=$r -d r=$r_hs -d Start=$Start -d Duree_HS=$Duree_HS -d Duree_tot=$Duree_tot $SCRIPT) >> $LOG/loci_${loci}  2>&1

	fi
done


#Commande pour run le programme
#cd /home/jaeger/sshfs-path_2/Simulation_3/1_Script
#time(bash run_slim.bash -p 1 -c 0 --Ne 25000 --L 10000 --L_HS 100 --n 14 --Start 7000 --Duree_HS 7000 --Duree_tot 14000) 
