# Create a resource Group
$resourceGroup = New-AzResourceGroup -Name 'fromps1' -Location 'eastus'

# Create a virtual Network
# create a subnet config
$webSubnet = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '192.168.0.0/24'
$appSubnet = New-AzVirtualNetworkSubnetConfig -Name 'app' -AddressPrefix '192.168.1.0/24'
$dbSubnet = New-AzVirtualNetworkSubnetConfig -Name 'db' -AddressPrefix '192.168.2.0/24'
$mgmtSubnet = New-AzVirtualNetworkSubnetConfig -Name 'mgmt' -AddressPrefix '192.168.3.0/24'

$ntier = New-AzVirtualNetwork -Name 'ntier' `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location -AddressPrefix '192.168.0.0/16'  `
    -Subnet $webSubnet,$appSubnet,$dbSubnet,$mgmtSubnet