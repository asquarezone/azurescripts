$resourceGroupName = 'cosmosdbps'
$location = 'eastus'

New-AzResourceGroup -Name $resourceGroupName -Location $location

New-AzCosmosDbAccount -ApiKind 'MongoDB' -Location $location  `
    -Name 'qtcosmosfromps1' -PublicNetworkAccess 'Enabled' `
    -ResourceGroupName $resourceGroupName -ServerVersion '4.0' 

New-AzCosmosDBMongoDBDatabase -Name 'instacook' -AccountName 'qtcosmosfromps1' `
    -ResourceGroupName $resourceGroupName

Remove-AzResourceGroup -Name $resourceGroupName -Confirm