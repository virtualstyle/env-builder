#!/bin/bash

# This is a run once script, so check if we haven't ran, or if the init_server 
# flag is set, run, otherwise skip. we'll set $run_bookmark to this script's
# filename, plus "-complete" and use that file's existence as a flag.
run_bookmark=ran_once/"$(basename $BASH_SOURCE)-complete"
# This script will always run if it does not find the bookmark file it creates
# in ran_once, and we can easily set properties to force this script to run 
# with a logical OR.
if [ ! -f $run_bookmark ] || [ "$run_another_thing_flag" == "true" ]; then

  echo "$(basename $BASH_SOURCE)"
  
  # Save the bookmark file to prevent reruns  
  touch $run_bookmark
fi