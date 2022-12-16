#!/bin/bash

for vm_id in $(az resource list --resource-type "Microsoft.Compute/VirtualMachines" --query "[?tags.Environment=='Dev'].id" --output "tsv")
do
    echo "Deallocating vm with id ${vm_id}"
    az vm deallocate  --ids "$vm_id"
done