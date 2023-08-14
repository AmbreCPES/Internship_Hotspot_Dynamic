#! /bin/bash

STR_2=""
for param in $(seq 1 9)
do

cd /beegfs/data/ajaeger/Simulation_3/2_Data_Slim/Out_Slim/Param_$param

STR_1=""
for i in $(seq 0 1)
do
STR=""
d=$(echo "($i*1000)+1" | bc)
f=$(echo "($i+1)*1000" | bc)

for ind in $(seq $d $f)
do
	if [ -f ./loci_${ind}/outputFasta_${ind} ] ; then STR=$STR"./loci_"$ind"/outputFasta_"$ind" " ; fi	
done

paste -d" " $STR >  /beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet/concatenateFasta_${param}_${i}

STR_1=$STR_1"concatenateFasta_"$param"_"$i" "
done

cd /beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet
paste -d" " $STR_1 >  /beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet/concatenateFasta_${param}

STR_2=$STR_2"concatenateFasta_"$param" "
done


cd /beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet

paste -d" " $STR_2 >  /beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet/concatenateFasta_tot

sed -i 's/ //g' /beegfs/data/ajaeger/Simulation_3/3_Output_ldhelmet/concatenateFasta_tot

grep -o '>genome5' concatenateFasta_tot | wc -l > /beegfs/data/ajaeger/Simulation_3/log/ldhelmet/Concatenate_check 2>&1

