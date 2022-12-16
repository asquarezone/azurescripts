
for group_id in $( az group list --query "[].id" --output tsv)
do
    # tag individual resource group

    az tag create --resource-id $group_id --tags "Environment=Dev"
done 