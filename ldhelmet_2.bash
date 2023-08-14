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
		-p|--param)
			param="$2"
			shift # past argument
			;;
		-c|--COUNT)
			COUNT="$2"
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


#RJMCMC 
if [ ! -d ${OUT}/Param_${param} ]
then mkdir ${OUT}/Param_${param}
fi

if [ ! -d /beegfs/data/ajaeger/${folder}/log/ldhelmet/rjmcmc_3 ]
then mkdir /beegfs/data/ajaeger/${folder}/log/ldhelmet/rjmcmc_3
fi

cd /beegfs/data/ajaeger/${folder}/2_Data_Slim/Out_Slim/Param_${param}
for ((ind=1; ind<=100; ind++))
do
loci=$(echo "(100*$COUNT)+$ind" | bc)
if [ ! -f ${OUT}/Param_${param}/output_${loci}.text ]
then
LOG=/beegfs/data/ajaeger/${folder}/log/ldhelmet/rjmcmc_3/rjmcmc_${param}_${loci}.log
	(echo "Run de rjmcmc") > $LOG  2>&1 
	(time(ldhelmet rjmcmc --num_threads 2 -l ${OUT}/output.lk -w 50 -b $b -s ./loci_${loci}/outputFasta_${loci} -a ./loci_${loci}/ancPriors_${loci} --burn_in $burn_in -n $n -p ${OUT}/output.pade -o ${OUT}/Param_${param}/output_${loci}.post)) >> $LOG  2>&1 
	
	
	(time(ldhelmet post_to_text -m -p 0.025 -p 0.50 -p 0.975 -o ${OUT}/Param_${param}/output_${loci}.text ${OUT}/Param_${param}/output_${loci}.post)) >> $LOG  2>&1 
fi
done
