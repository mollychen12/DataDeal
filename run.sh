#!/bin/bash
##The bash sript is used to change the velocity 

#get the info of the processor
pod=hostname
pid=$$
echo "The pod:${pod}"
echo "The pid:${pid}"

#list the array
x_velocity=(0.1 0.2 0.3 0.4)
y_velocity=(0.1 0.2 0.3 0.4)
angle=(5 10 15 20 25)

#trasverse the angle and run
for index in 0 1 2 3 4;do
  echo "Make dir angle-${angle[${index}]}"
  cp -r demo angle-${angle[$(index)]}
  cd angle-${angle[$(index)]}
  
  echo "x velocity: ${x_velocity[${index}]}"
  echo "y velocity: ${y_velocity[${index}]}"
  sed -i "s/xxx/${x_velocity[${index}]}/g" 0/U
  sed -i "s/xxx/${y_velocity[${index}]}/g" 0/U
  
  decomposePar >>decompose.log
  mpirun --allow-run-as-root -np 8 simpleFoam -parallel >>nProcs.log
  
  cd ..
done


