# Create a new resource group
$group_name = 'sqlfromps'
$location = 'eastus'

$group = New-AzResourceGroup -Name $group_name -Location $location

# Create the Server
$sqlserver_name = 'qtsqlserverfromps1'
$sqlserver = New-AzSqlServer -ResourceGroupName $group.ResourceGroupName `
    -Location $location -ServerName $sqlserver_name `
    -SqlAdministratorCredentials (Get-Credential)

# Create an Azure SQL Single database
$database_name = 'qtsqlforps'
$database_edition = 'Basic'
$database = New-AzSqlDatabase -ResourceGroupName $group.ResourceGroupName `
    -ServerName $sqlserver.ServerName -DatabaseName $database_name `
    -Edition $database_edition -SampleName 'AdventureWorksLT'

# Create an Sql Server Firewall
$start_ip = '0.0.0.0'
$end_ip = '255.255.255.255'
$firewall_rule_name = "allowall"
New-AzSqlServerFirewallRule -ResourceGroupName $group.ResourceGroupName `
    -ServerName $sqlserver.ServerName -FirewallRuleName $firewall_rule_name `
    -StartIpAddress $start_ip -EndIpAddress $end_ip

Write-Host "Use the following settings Server Address" $sqlserver.FullyQualifiedDomainName