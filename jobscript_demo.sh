#!/bin/bash

#Loop starts
for a in 1 2 3 4 5
do
    # Condition starts
    if [ $a == $target ]
    then
      echo "Skipping $target"
      sleep 5
    else
      echo "Loop Nº $a"
    fi
done
