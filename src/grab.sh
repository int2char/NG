#!/bin/bash
rm -f ./data/*.txt
nodes=(1000)
types=(2)
graphtype=("ER" "NI" "BA")
powers=(6) 
capacitys=(100)
declare -i edge task biao 
for node in ${nodes[@]}
do
  for type in ${types[@]}
  do
   path="../result/$node/$type/"
   edge=`cat $path/Graph.txt|wc -l`
   edge=$edge+$edge
    for power in ${powers[@]}
    do
      task=$[$power*$node]
      biao=$type
      rm -f *.out
      nvcc -O3 -std=c++11 *.cpp *.cu --gpu-architecture=compute_35 --gpu-code=sm_35 -I ../include -I ../cplex_include -L ../lib -lconcert -lcplex -lilocplex -lm -lpthread -DIL_STD -DNODE=$node -DEDge=$edge -DTask=$task -DTYPE="\"${graphtype[$biao]}\"" -DINPUTFILE=\"$path\" -DGANOEX=1 
     #CUDA_VISIBLE_DEVICES=1 ./a.out S 1>>./data/runinfo.txt 2>>./data/err.txt
    done
  done
done
