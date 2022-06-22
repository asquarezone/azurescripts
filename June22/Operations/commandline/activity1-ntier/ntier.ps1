# Create a resource group

$location = 'centralus'
$resg_name = 'ntier-ps'

$resg = New-AzResourceGroup -Name $resg_name -Location $location

$web = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '10.11.0.0/24'
$business = New-AzVirtualNetworkSubnetConfig -Name 'business' -AddressPrefix '10.11.1.0/24'
$data = New-AzVirtualNetworkSubnetConfig -Name 'data' -AddressPrefix '10.11.2.0/24'

$vnet = New-AzVirtualNetwork -Name 'ntier' -ResourceGroupName $resg_name -Location $location -Subnet $web,$business,$data -AddressPrefix '10.11.0.0/16'

$dbserverName = 'qtsqlserverps1'

Write-Host "Creating the database server"
$server = New-AzSqlServer -ServerName $dbserverName `
    -Location $location `
    -ResourceGroupName $resg_name `
    -ServerVersion '12.0' `
    -SqlAdministratorCredentials (Get-Credential)


Write-Host "Creating firewall rule"
New-AzSqlServerFirewallRule -FirewallRuleName 'openall' `
    -ResourceGroupName $resg_name `
    -StartIpAddress '0.0.0.0' `
    -EndIpAddress '255.255.255.255' `
    -ServerName $dbserverName


Write-Host "Creating Database"
$dbName = 'qtemployeesdb'
$database = New-AzSqlDatabase -ResourceGroupName $resg_name `
    -DatabaseName $dbName `
    -ServerName $dbserverName `
    -Edition 'GeneralPurpose' `
    -ComputeModel 'Serverless' `
    -ComputeGeneration 'Gen5' `
    -VCore 2 `
    -SampleName "AdventureWorksLT" `
    -MinimumCapacity 2


New-AzVM `
    -ResourceGroupName $resg_name `
    -Name 'appserver' `
    -Image 'Centos' `
    -Size 'Standard_B1s' `
    -Credential (Get-Credential) `
    -SubnetName 'business' `
    -VirtualNetworkName 'ntier'
    
    
New-AzVM `
    -ResourceGroupName $resg_name `
    -Name 'webserver' `
    -Image 'UbuntuLTS' `
    -Size 'Standard_B1s' `
    -Credential (Get-Credential) `
    -SubnetName 'web' `
    -VirtualNetworkName 'ntier'