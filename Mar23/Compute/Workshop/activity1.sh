#!/bin/bash

tag_name=$1
tag_value=$2

# Get the vm ids of the machines with tag Env and value Dev
vmIds=$(az vm list --query "[?tags.$tag_name=='$tag_value'].id" --output tsv)


if [[ -z "$vmIds" ]]; then
  echo "No vms found with tag $tag_name = $tag_value"
elif [[ -n "$vmIds" ]]; then
  echo "vm ids are ${vmIds}"
  az vm deallocate --ids $vmIds
fi

# run the below statements when vmIds is not empty
