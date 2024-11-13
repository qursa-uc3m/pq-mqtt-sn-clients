#!/bin/bash

# Ejecutar el cliente

for i in $(seq 1 2)
do

a=$(date +%s%3N)
echo "RINNUING PUB"
./sn-pub -t > "out.log" 2>&1

b=$(date +%s%3N)

resta=$(($a-$b))

#echo $a

#echo $b

echo "Cliente $i : $resta ms" >> "sn-pub.log"

sleep 1

done