#!/bin/bash

for group in $(az group list --query "[].name" --tag "Environment=Dev" --output tsv)
do
    echo "Deleting resource group"
    az group delete --name $group
done