#!/bin/bash

# Get the vm ids of the machines with tag Env and value Dev
vmIds=$(az vm list --query "[?tags.Env=='Dev'].id" --output tsv)


if [[ -z "$vmIds" ]]; then
  echo "No vms found with tag Env = Dev"
elif [[ -n "$vmIds" ]]; then
  echo "vm ids are ${vmIds}"
  az vm deallocate --ids $vmIds
fi

# run the below statements when vmIds is not empty
