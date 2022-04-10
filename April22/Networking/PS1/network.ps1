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



# create a subnet config
$web1Subnet = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '172.16.0.0/24'
$app1Subnet = New-AzVirtualNetworkSubnetConfig -Name 'app' -AddressPrefix '172.16.1.0/24'
$db1Subnet = New-AzVirtualNetworkSubnetConfig -Name 'db' -AddressPrefix '172.16.2.0/24'
$mgmt1Subnet = New-AzVirtualNetworkSubnetConfig -Name 'mgmt' -AddressPrefix '172.16.3.0/24'

$ntier1 = New-AzVirtualNetwork -Name 'ntier1' `
    -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location -AddressPrefix '172.16.0.0/16'  `
    -Subnet $web1Subnet,$app1Subnet,$db1Subnet,$mgmt1Subnet


# Peering from ntier to ntier1
$ntiertontier1peering = Add-AzVirtualNetworkPeering -Name 'ntiertontier1' -VirtualNetwork $ntier `
    -RemoteVirtualNetworkId $ntier1.Id

# Peering from ntier1 to ntier
$ntier1tontierpeering = Add-AzVirtualNetworkPeering -Name 'ntier1tontier' -VirtualNetwork $ntier1 `
    -RemoteVirtualNetworkId $ntier.Id


