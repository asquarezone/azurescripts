$resourceGroupName = 'querySQLRG'
$location = 'eastus'

Write-Host "Creating Resource Group with name = $resourceGroupName and location = $location"

New-AzResourceGroup -Name $resourceGroupName -Location $location

$createdResourceGroup = Get-AzResourceGroup -Name $resourceGroupName -Location $location

Write-Host "Resource group created and selected $createdResourceGroup"

# Create the Server
$sqlserver_name = 'qtsqlserverfromps1'
$sqlserver = New-AzSqlServer -ResourceGroupName $createdResourceGroup.ResourceGroupName `
    -Location $location -ServerName $sqlserver_name `
    -SqlAdministratorCredentials (Get-Credential)

$sqlserver = Get-AzSqlServer -ServerName 'qtsqlserverfromps1' -ResourceGroupName 'querySQLRG'

$database_name = 'qtsqlforps'
$database_edition = 'GeneralPurpose'
$computeModel = 'Serverless'
$database = New-AzSqlDatabase `
        -ResourceGroupName $createdResourceGroup.ResourceGroupName `
        -ServerName $sqlserver.ServerName -DatabaseName $database_name `
        -Edition $database_edition -SampleName 'AdventureWorksLT' `
        -ComputeModel $computeModel -ComputeGeneration 'Gen5' `
        -MinimumCapacity 2 
