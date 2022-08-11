$resg_name = 'activity1ps1'
$vnet_address = '172.16.0.0/22'
$location = "Centralus"
$websubnet = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix "172.16.0.0/24"
$appsubnet = New-AzVirtualNetworkSubnetConfig -Name 'app' -AddressPrefix "172.16.1.0/24"
$cachesubnet = New-AzVirtualNetworkSubnetConfig -Name 'cache' -AddressPrefix "172.16.2.0/24"
$dbsubnet = New-AzVirtualNetworkSubnetConfig -Name 'db' -AddressPrefix "172.16.3.0/24"
New-AzVirtualNetwork -Name 'ntier' -ResourceGroupName $resg_name -AddressPrefix $vnet_address -Subnet $websubnet,$appsubnet,$cachesubnet,$dbsubnet -Location $location
