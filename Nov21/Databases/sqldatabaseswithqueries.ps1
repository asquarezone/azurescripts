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

# Create an Sql Server Firewall
$start_ip = '0.0.0.0'
$end_ip = '255.255.255.255'
$firewall_rule_name = "allowall"
New-AzSqlServerFirewallRule -ResourceGroupName $createdResourceGroup.ResourceGroupName `
    -ServerName $sqlserver.ServerName -FirewallRuleName $firewall_rule_name `
    -StartIpAddress $start_ip -EndIpAddress $end_ip

# Partner Server
$new_location = 'centralus'
New-AzSqlServer -ResourceGroupName $createdResourceGroup.ResourceGroupName `
    -Location $new_location -ServerName 'qtsqlsrvsec02' `
    -SqlAdministratorCredentials (Get-Credential)

New-AzSqlServerFirewallRule -ResourceGroupName $createdResourceGroup.ResourceGroupName `
    -ServerName 'qtsqlsrvsec02' -FirewallRuleName 'allow_all_secondary' `
    -StartIpAddress $start_ip -EndIpAddress $end_ip


# Create the active geo replication
New-AzSqlDatabaseSecondary -DatabaseName 'sqldbsecondary' `
    -ResourceGroupName $createdResourceGroup.ResourceGroupName `
    -ServerName $sqlserver.ServerName `
    -PartnerResourceGroupName $createdResourceGroup.ResourceGroupName `
    -PartnerServerName 'qtsqlsrvsec02' -AllowConnections 'All'

