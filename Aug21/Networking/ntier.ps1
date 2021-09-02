$resg = New-AzResourceGroup -Name 'ntierps' -Location 'eastus'
#Write-Host $resg.ResourceGroupName
#Write-Host $resg.Location
$appgw = New-AzVirtualNetworkSubnetConfig -AddressPrefix '192.168.0.0/24' -Name 'appgw'
$mgmt = New-AzVirtualNetworkSubnetConfig -AddressPrefix '192.168.1.0/24' -Name 'mgmt'
$web = New-AzVirtualNetworkSubnetConfig -AddressPrefix '192.168.2.0/24' -Name 'web'
$business = New-AzVirtualNetworkSubnetConfig -AddressPrefix '192.168.3.0/24' -Name 'business'
$data = New-AzVirtualNetworkSubnetConfig -AddressPrefix '192.168.4.0/24' -Name 'data'
$ad = New-AzVirtualNetworkSubnetConfig -AddressPrefix '192.168.5.0/24' -Name 'ad'

$ntier = New-AzVirtualNetwork -Name 'ntier' -ResourceGroupName $resg.ResourceGroupName -Location $resg.Location -AddressPrefix '192.168.0.0/16' -Subnet $appgw,$mgmt,$web,$business,$data,$ad

$openports = New-AzNetworkSecurityRuleConfig -Name 'openports' -Access 'Allow' -SourcePortRange '*' -SourceAddressPrefix '*' -DestinationAddressPrefix '*' -DestinationPortRange '22','80','443' -Priority '410' -Protocol 'Tcp' -Direction 'Inbound'

$denyfromdata = New-AzNetworkSecurityRuleConfig -Name 'deny' -Access 'Deny' -SourceAddressPrefix '192.168.4.0/24' -SourcePortRange '*' -DestinationPortRange '*' -DestinationAddressPrefix '*' -Priority '400'-Protocol 'Tcp' -Direction 'Inbound'

$nsg = New-AzNetworkSecurityGroup -Name 'ntiernsg' -ResourceGroupName $resg.ResourceGroupName -Location $resg.Location -SecurityRules $openports,$denyfromdata