#!/bin/bash

# batch_job arguments
# $1 = type , $2 = Wp mass , $3 = KL , $4 = nevents

type=$1

type1_array1=("10" "100" "500" "1000" "1500")
type1_array2=("100" "500" "1000" "1500" "-1")

type2_array1=("10" "100" "500" "1000" "1500" "2500")
type2_array2=("100" "500" "1000" "1500" "2500" "-1")

if [ $type -eq "1" ] ; then event_array1=(${type1_array1[@]}) ; event_array2=(${type1_array2[@]}) ; ((count=5)) ; elif [ $type -eq "2" ] ; then event_array1=(${type2_array1[@]}) ; event_array2=(${type2_array2[@]}) ; ((count=6)) ; else echo "error : invalid type number" ; fi

for ((i=0 ; i<$count ; i+=1 )) ; do
((j=$i+1))
./RUN.sh $2 $3 ${j} $4 ${event_array1[i]} ${event_array2[i]}
done



# RUN.sh arguments
# argv1 = Wp mass
# argv2 = coupling constant(kL)
# argv3 = file number

# argv4 = nevents
# argv5 = ptl
# argv6 = ptlmax
