$resg_name = 'activity1ps1'
$vnet_address = '172.16.0.0/23'
$location = "Centralus"
$resg = New-AzResourceGroup -Name $resg_name -Location $location
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name 'subnet1' -AddressPrefix "172.16.0.0/24"
$subnet2 = New-AzVirtualNetworkSubnetConfig -Name 'subnet2' -AddressPrefix "172.16.1.0/24"
$vnet = New-AzVirtualNetwork -Name 'fromps1' -ResourceGroupName $resg_name -Location $location -AddressPrefix $vnet_address -Subnet $subnet1,$subnet2
