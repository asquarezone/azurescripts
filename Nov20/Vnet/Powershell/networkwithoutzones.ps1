# Create a resource group
$resource_group_name = "vnetwithoutzones-ps"
$resource_group_location = "South India"

New-AzResourceGroup -Name $resource_group_name -Location $resource_group_location

# add subnets
$web_subnet = New-AzVirtualNetworkSubnetConfig -Name "web" -AddressPrefix "10.10.0.0/24"

$app_subnet = New-AzVirtualNetworkSubnetConfig -Name "app" -AddressPrefix "10.10.1.0/24"

$db_subnet = New-AzVirtualNetworkSubnetConfig -Name "db"  -AddressPrefix "10.10.2.0/24"

$mgmt_subnet = New-AzVirtualNetworkSubnetConfig -Name "mgmt" -AddressPrefix "10.10.3.0/24"

# Create a virtual network and assign subnets 
New-AzVirtualNetwork -AddressPrefix "10.10.0.0/16" -ResourceGroupName $resource_group_name -Location $resource_group_location -Subnet $web_subnet,$app_subnet,$db_subnet,$mgmt_subnet -Name 'ntier'
