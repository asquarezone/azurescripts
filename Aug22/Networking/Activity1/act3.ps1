$resourceGroupName = 'activity3'
$location1 = 'centralus'
$location2 = 'eastus'
$addressSpaceLocation1 = '10.100.0.0/16'
$addressSpaceLocation2 = '10.101.0.0/16'

$resourceGroup = New-AzResourceGroup -ResourceGroupName $resourceGroupName -Location $location1

$web1 = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '10.100.0.0/24'
$app1 = New-AzVirtualNetworkSubnetConfig -Name 'app' -AddressPrefix '10.100.1.0/24'
$cache1 = New-AzVirtualNetworkSubnetConfig -Name 'cache' -AddressPrefix '10.100.2.0/24'
$db1 = New-AzVirtualNetworkSubnetConfig -Name 'db' -AddressPrefix '10.100.3.0/24'
$mgmt1 = New-AzVirtualNetworkSubnetConfig -Name 'mgmt' -AddressPrefix '10.100.4.0/24'
$vnetPrimary = New-AzVirtualNetwork -Name 'ntier-primary' `
                -ResourceGroupName $resourceGroup.ResourceGroupName `
                -Location $location1 `
                -Subnet $web1,$app1,$cache1,$db1,$mgmt1 `
                -AddressPrefix $addressSpaceLocation1



$web2 = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '10.101.0.0/24'
$app2 = New-AzVirtualNetworkSubnetConfig -Name 'app' -AddressPrefix '10.101.1.0/24'
$cache2 = New-AzVirtualNetworkSubnetConfig -Name 'cache' -AddressPrefix '10.101.2.0/24'
$db2 = New-AzVirtualNetworkSubnetConfig -Name 'db' -AddressPrefix '10.101.3.0/24'
$mgmt2 = New-AzVirtualNetworkSubnetConfig -Name 'mgmt' -AddressPrefix '10.101.4.0/24'

$vnetSecondary = New-AzVirtualNetwork `
                    -Name 'ntier-secondary' `
                    -ResourceGroupName $resourceGroup.ResourceGroupName `
                    -Location $location2 `
                    -Subnet $web2,$app2,$cache2,$db2,$mgmt2 `
                    -AddressPrefix $addressSpaceLocation2 

# Create a NSG with default security rules

$internalNsg = New-AzNetworkSecurityGroup `
                -Name 'internalprimary' `
                -Location $location1 `
                -ResourceGroupName $resourceGroup.ResourceGroupName

Set-AzVirtualNetworkSubnetConfig `
    -Name 'app' `
    -NetworkSecurityGroupId $internalNsg.Id `
    -VirtualNetwork $vnetPrimary `
    -AddressPrefix '10.100.1.0/24'

Set-AzVirtualNetworkSubnetConfig `
    -Name 'cache' `
    -NetworkSecurityGroupId $internalNsg.Id `
    -VirtualNetwork $vnetPrimary `
    -AddressPrefix '10.100.2.0/24'

Set-AzVirtualNetworkSubnetConfig `
    -Name 'db' `
    -NetworkSecurityGroupId $internalNsg.Id `
    -VirtualNetwork $vnetPrimary `
    -AddressPrefix '10.100.3.0/24'

$vnetPrimary | Set-AzVirtualNetwork

$internalNsgSecondary = New-AzNetworkSecurityGroup `
                        -Name 'internalsecondary' `
                        -Location $location2 `
                        -ResourceGroupName $resourceGroup.ResourceGroupName
        
                        
Set-AzVirtualNetworkSubnetConfig `
    -Name 'app' `
    -NetworkSecurityGroupId $internalNsgSecondary.Id `
    -VirtualNetwork $vnetSecondary `
    -AddressPrefix '10.101.1.0/24'

Set-AzVirtualNetworkSubnetConfig `
    -Name 'cache' `
    -NetworkSecurityGroupId $internalNsgSecondary.Id `
    -VirtualNetwork $vnetSecondary `
    -AddressPrefix '10.101.2.0/24'

Set-AzVirtualNetworkSubnetConfig `
    -Name 'db' `
    -NetworkSecurityGroupId $internalNsgSecondary.Id `
    -VirtualNetwork $vnetSecondary `
    -AddressPrefix '10.101.3.0/24'

$vnetSecondary | Set-AzVirtualNetwork


# Creating a Peering connection from primary to secondary

Add-AzVirtualNetworkPeering -Name 'primarytosecondary' `
    -VirtualNetwork $vnetPrimary `
    -RemoteVirtualNetworkId $vnetSecondary.Id

#  Create a Peering connection from secondary to primary

Add-AzVirtualNetworkPeering -Name 'secondarytoprimary' `
    -VirtualNetwork $vnetSecondary `
    -RemoteVirtualNetworkId $vnetPrimary.Id
    
