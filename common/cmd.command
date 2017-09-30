#!/bin/bash

# Load our parsed command line arguments into their proper property variables,
# The following options take arguments to override properties:
# -a/--arg = arg_var
# The following flags are for convenience:
# -y to allow noninteractive default build
while true; do
  case "$1" in
    -a|--arg)
        arg_var="$2"
        shift 2
        ;;
    -y)
        noninteractive="true"
        shift
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Programming error"
        exit 3
        ;;
  esac
done
