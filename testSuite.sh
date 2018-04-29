#!/bin/bash
TESTING_ITERATIONS=5
if [ $# -eq 0 ]; then
  # all benchmarks with 5 interations
  # e.g. ./testSuite
  FILES=`find . -name "main.lua"`
elif [ $# -eq 1 ]; then
  # all benchmarks with i iterations
  # e.g. ./testSuite 4
  FILES=`find . -name "main.lua"`
  TESTING_ITERATIONS=$1
else
  # only benchmarks in the argument and with i iterations
  # e.g. ./testSuite.sh 2 Circle\ Physics/main.lua
  TESTING_ITERATIONS=$1
  FILES=$2
fi

while read -r LINE; do
  NAME=`dirname "${LINE}"`
  results[0]=0
  sum=0
  max=0
  min=999999999
  echo "----- "${NAME:2}" -----"
  for (( i=0; i<$TESTING_ITERATIONS; i++ ))
  do
    results[$i]=$(love "`dirname "${LINE%.*}"`/")
    echo "$i: ${results[$i]}"
    val=${results[i]}
    sum=$((sum+val))
    if [ "$val" -gt "$max" ]; then
      max="$val"
    fi
    if [ "$val" -lt "$min" ]; then
      min="$val"
    fi
  done
  echo "AVG: $((sum/TESTING_ITERATIONS))"
  echo "MIN: $min"
  echo "MAX: $max"
done <<< "$FILES"
