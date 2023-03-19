#!/bin/bash

source ./utils.sh

tag_name=$(assign_default_value_if_empty $1 'Env')
tag_value=$(assign_default_value_if_empty $2 'Dev')


# Get the vm ids of the machines with tag Env and value Dev
vmIds=$(az vm list --query "[?tags.$tag_name=='$tag_value'].id" --output tsv)


if [[ -z "$vmIds" ]]; then
  echo "No vms found with tag $tag_name = $tag_value"
elif [[ -n "$vmIds" ]]; then
  echo "vm ids are ${vmIds}"
  az vm start --ids $vmIds
fi


