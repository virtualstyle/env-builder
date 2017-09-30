#!/bin/bash

echo "$(basename $BASH_SOURCE)"

if [ "$noninteractive" != "true" ]; then
  echo "Prompt for some info"
  read somevar
else 
  somevar="default noninteractive"
fi

echo "Prompted var (or default): $somevar"

echo "Running with config vars:"
echo "$common_property"
echo "$another_property"
