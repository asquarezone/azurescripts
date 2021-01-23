# Creating a resource group
$resg = New-AzResourceGroup -Name 'sqlfromps' -Location 'eastus'

# Create azure sql server
$azure_sql_server = New-AzSqlServer -ResourceGroupName $resg.ResourceGroupName -Location $resg.Location -ServerName 'qtsqlfromps' -SqlAdministratorCredentials (Get-Credential) -PublicNetworkAccess 'Enabled'

# Create a firewall rule
$server_firewall = New-AzSqlServerFirewallRule -ResourceGroupName $resg.ResourceGroupName -ServerName $azure_sql_server.ServerName -FirewallRuleName 'openall' -StartIpAddress '0.0.0.0' -EndIpAddress '255.255.255.255'

# Create a single database
$azure_sql_db = New-AzSqlDatabase -ResourceGroupName $resg.ResourceGroupName -ServerName $azure_sql_server.ServerName -SampleName 'AdventureWorksLT' -DatabaseName 'qtsqldbfromps' -Edition 'Basic'