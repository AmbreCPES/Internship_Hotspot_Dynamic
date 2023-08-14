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

IN=/home/jaeger/sshfs-path_2/Simulation_ld/3_Output_ldhelmet
OUT=/home/jaeger/sshfs-path_2/Simulation_ld/3_Output_ldhelmet
folder=Simulation_ld

b=50.0
pade=FALSE
burn_in=100000
n=1000000

while [[ $# -gt 1   ]]
do
	key="$1"

	case $key in
		-p|--param)
			param="$2"
			shift # past argument
			;;

		--Ne)
			Ne="$2"
			shift # past argument
			;;
			
		--mu)
			mu="$2"
			shift # past argument
			;;
		--N)
			N="$2"
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
		--pade)
			pade="$2"
			shift # past argument
			;;
		--burn_in)
			burn_in="$2"
			shift # past argument
			;;
		--n)
			n="$2"
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
#LOG=/home/jaeger/stage/${folder}/log/ldhelmet/find_confs_${param}.log
#(echo "Run de find_confs") > $LOG  2>&1 
#(time(ldhelmet find_confs --num_threads 2 -w 50 -o ${OUT}/output_${param}.conf ${IN}/concatenateFasta_${param})) >> $LOG  2>&1 


#table_gen
#LOG=/home/jaeger/stage/${folder}/log/ldhelmet/table_gen_${param}.log
#(echo "Run de table_gen") > $LOG  2>&1 
#(time(ldhelmet table_gen --num_threads 2 -c ${OUT}/output_${param}.conf -t $theta -r ${rhos} -o ${OUT}/output_${param}.lk)) >> $LOG  2>&1 


#OPTIONAL: pade coefficient, not calculated cause lack of time
#LOG=/home/jaeger/stage/${folder}/log/ldhelmet/pade_${param}.log 
#(echo "Run de pade") > $LOG  2>&1
#(time(ldhelmet pade --num_threads 2 -c ${OUT}/output_${param}.conf -t $theta -x 11 -o ${OUT}/output_${param}.pade)) > $LOG  2>&1 

#RJMCMC 
if [ ! -d ${OUT}/Param_${param} ]
then mkdir ${OUT}/Param_${param}
fi

if [ ! -d /home/jaeger/stage/${folder}/log/ldhelmet/rjmcmc.2 ]
then mkdir /home/jaeger/stage/${folder}/log/ldhelmet/rjmcmc.2
fi

cd /home/jaeger/stage/${folder}/2_Data_Slim/Out_Slim/Param_${param}
for ((loci=1; loci<=$N; loci++))
do
LOG=/home/jaeger/stage/${folder}/log/ldhelmet/rjmcmc/rjmcmc_${param}_${loci}.2.log
	(echo "Run de rjmcmc") > $LOG  2>&1 
	if [ -f ./loci_${loci}/ancPriors_${loci} ]
		then (time(ldhelmet rjmcmc --num_threads 2 -l ${OUT}/output_${param}.lk -w 50 -b $b -s ./loci_${loci}/outputFasta_${loci} -a ./loci_${loci}/ancPriors_${loci} --burn_in $burn_in -n $n -o ${OUT}/Param_${param}/output_${loci}.post)) >> $LOG  2>&1 
	fi
	
	(time(ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.975 -o ${OUT}/Param_${param}/output_${loci}.text ${OUT}/Param_${param}/output_${loci}.post)) >> $LOG  2>&1 
done


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
####                              TO EXECUTE                               ####
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

#cd /home/jaeger/stage/Simulation_ld/1_Script
#bash run_ldhelmet_f.bash -p 10 --b 50.0 --burn_in 100000 --n 1000000 --N 100 --mu $(echo "scale=10;1.25*10^-8"|bc)  

