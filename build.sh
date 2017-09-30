#!/bin/bash

# Check for our required structure/files
# The common folder will hold default properties files and config scripts.
if [ ! -d common ]; then
  echo "No common directory found."
  exit
fi
# The ran_once directory will hold bookmark files to know if a script has
# run already, to avoid unnecessary reruns.
if [ ! -d ran_once ]; then
  echo "No ran_once directory found."
  exit
fi

# Get any common properties files from the common folder and load them.
for i in common/*.properties; do
  [ -f "$i" ] || break
  . $i
done

# If none of the common .properties files have set $target_environment, notify
# the user and die.
if [ -z "$target_environment" ]; then
  echo "No target_environment set in common property files."
  exit
fi

# If a target_environment is specified, make sure it exists.
if [ ! -d "$target_environment" ]; then
  echo "No $target_environment directory found."
  exit
fi

# Save the target_environment so we can check to make sure no subsequent files
# override it.
env_save=$target_environment

# Get any environment properties files from the target_environment folder 
# and load them,overriding any set in the common file.
for i in $target_environment/*.properties; do
  [ -f "$i" ] || break
  . $i
done

# If they overrode the target_environment, that's a problem, since we already
# loaded the environment, notify and die so they can fix it.
if [ "$target_environment" != "$env_save" ]; then
  echo "Target environment cannot be changed in environment properties file in $env_save environment directory"
  exit
fi

noninteractive="false"

# We'll allow command line options to override the properties files, and parse
# the arguments with getopt, so if the environment doesn't have getopt, die.
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "`getopt --test` failed in this environment."
    exit 1
fi

# Temporarily store output to be able to check for errors
# Activate advanced mode getopt quoting e.g. via “--options”
# Pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  Getopt has complained about wrong arguments to stdout
    exit 2
fi
# Eval with "$PARSED" to properly handle quoting
eval set -- "$PARSED"

if [ -f "$OPTION_HANDLER_FILE" ]; then
  . $OPTION_HANDLER_FILE
fi

# Accumulator for missing properties to notify user.
missing_properties=()

# Loop through required_properties and add any empty/nonexistent ones to our
# accumulator array.
for i in "${required_properties[@]}"
do
  if [ -z "${!i}"  ]; then
    missing_properties+=($i)
  fi
done

# If we're missing required properties, notify the user and die.
if [ ! ${#missing_properties[@]} -eq 0 ]; then
  echo "Required configuration properties are missing. Please check the following in the properties file:"
  for i in "${missing_properties[@]}"
  do
    echo "$i"
  done
  exit
fi

exec_queue=()

# If the suppress_common flag isn't true, get any common shell scripts from the 
# common folder and load them in an execution queue.
if [ "$suppress_common" != "true" ]; then
  for i in common/*.sh; do
    [ -f "$i" ] || break
    exec_queue+=("$(basename $i)-a")
  done
fi

# Get any environment shell scripts from the target_environment folder and load
# them in our execution queue (unless the enviropnment is "common").
if [ "$target_environment" != "common" ]; then
  for i in $target_environment/*.sh; do
    [ -f "$i" ] || break
    exec_queue+=("$(basename $i)-b")
  done
fi

# Sort the queue by the number after a hyphen.
IFS=$'\n' exec_queue=($(sort -n -t - -k 2 <<<"${exec_queue[*]}"))
unset IFS

# Execute each entry in the queue in order.
for i in "${!exec_queue[@]}"; do
  case ${exec_queue[$i]} in
    *-a)
      newval="common/${exec_queue[$i]%-a}"
      ;;
    *-b) 
      newval="$target_environment/${exec_queue[$i]%-b}"
      ;;
  esac
  . $newval
done


