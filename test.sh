#!/bin/bash

# Default values
iterations=1
mode="pub"  # Default to publisher mode

# Parse flags
while getopts "n:m:" opt; do
 case $opt in
   n) iterations=$OPTARG ;;
   m) mode=$OPTARG ;;
   *) echo "Usage: $0 [-n iterations] [-m pub|sub]" >&2
      exit 1 ;;
 esac
done

# Create tests_logs directory if it doesn't exist
mkdir -p ./tests_logs

for i in $(seq 1 $iterations)
do
 a=$(date +%s%3N)
 if [ "$mode" = "pub" ]; then
   echo "RUNNING PUBLISHER"
   ./build/bin/sn-pub -t > "./tests_logs/out.log" 2>&1
 else
   echo "RUNNING SUBSCRIBER"
   ./build/bin/sn-sub -t > "./tests_logs/out.log" 2>&1
 fi
 b=$(date +%s%3N)
 resta=$(($b-$a))
 echo "Cliente $i : $resta ms" >> "./tests_logs/sn-$mode.log"
 #sleep 1
done