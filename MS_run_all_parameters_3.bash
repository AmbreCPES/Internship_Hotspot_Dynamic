#! /bin/bash
#on génére pour les 9 set de parametres SLiM qu'on va d'obord tester, un script qui génère les mutations pour 20 000 loci qu'on va générer en SLiM

################
#VALUES
################
Ne=25000

mu=$(echo "scale=10;1.25*10^-8"|bc)
rho=$(echo "scale=10;1*10^-7"|bc)

t=$(echo "4.0*$Ne*$mu*10000.0" | bc)
r=$(echo "4.0*$Ne*$rho*10000.0" | bc)

OUT=/home/jaeger/stage/Simulation_ld/2_Data_Slim/In_ms

################
# Run the script
################

for ((param=3; param<=3; param++))
do
if [ ! -d ${OUT}//Param_${param} ]
then mkdir ${OUT}/Param_${param}
fi

for ((ind=1; ind<=1000; ind++))
do
loci=$ind
	
	/home/jaeger/my_ms/ms/msdir/ms 50000 1 -t $t -r $r 10000 > ${OUT}/Param_${param}/ms_${loci}.ms && \
	sed -i '1,4d' ${OUT}/Param_${param}/ms_${loci}.ms; sed -i s/' '\$//g ${OUT}/Param_${param}/ms_${loci}.ms
done


done

