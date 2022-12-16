#!/bin/bash
for id in $(az resource list --resource-group workshop --output tsv --query "[].id")
do
    echo "Resource id is $id"
    az tag create --resource-id "$id" \
        --tags "Environment=Dev" "Project=azurelearning" "Release=v1.1" "Team=qtazure"
done


