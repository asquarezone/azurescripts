# Create a resource group

$location = 'centralus'
$resg_name = 'ntier-ps'

$resg = New-AzResourceGroup -Name $resg_name -Location $location

$web = New-AzVirtualNetworkSubnetConfig -Name 'web' -AddressPrefix '10.11.0.0/24'
$business = New-AzVirtualNetworkSubnetConfig -Name 'business' -AddressPrefix '10.11.1.0/24'
$data = New-AzVirtualNetworkSubnetConfig -Name 'data' -AddressPrefix '10.11.2.0/24'

$vnet = New-AzVirtualNetwork -Name 'ntier' -ResourceGroupName $resg_name -Location $location -Subnet $web,$business,$data -AddressPrefix '10.11.0.0/16'

