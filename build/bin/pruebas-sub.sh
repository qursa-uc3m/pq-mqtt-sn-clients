#!/bin/bash

# Ejecutar el cliente

for i in $(seq 1 5)
do

a=$(date +%s%3N)

./sn-sub -t

b=$(date +%s%3N)

resta=$(($a-$b))

#echo $a

#echo $b

echo "Cliente $i : $resta ms" >> "sn-sub.log"

done