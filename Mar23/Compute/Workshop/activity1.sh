#!/bin/bash

# Get the vm ids of the machines with tag Env and value Dev
vmIds=$(az vm list --query "[?tags.Env=='Dev'].id" --output tsv)
echo "vm ids are ${vmIds}"

az vm deallocate --ids $vmIds