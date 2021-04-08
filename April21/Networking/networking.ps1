# Create a Resource Group
$resg = New-AzResourceGroup -Name 'fromps' -Location 'eastus'

# Create an Application Gateway Subnet
$appgwsubnet = New-AzVirtualNetworkSubnetConfig -Name 'ApplicationGatewaySubnet' -AddressPrefix '10.10.0.0/24' 

# Create a web tier subnet
$webtiersubnet = New-AzVirtualNetworkSubnetConfig -Name 'webtier' -AddressPrefix '10.10.1.0/24'

# Create a business tier subnet
$businesstiersubnet = New-AzVirtualNetworkSubnetConfig -Name 'businesstier' -AddressPrefix '10.10.2.0/24'

# Create a data tier subnet
$datatiersubnet = New-AzVirtualNetworkSubnetConfig -Name 'datatier' -AddressPrefix '10.10.3.0/24'

# Create a management tier subnet
$managementtiersubnet = New-AzVirtualNetworkSubnetConfig -Name 'managementtier' -AddressPrefix '10.10.4.0/24'

# Create an Active Directory subnet
$adsubnet = New-AzVirtualNetworkSubnetConfig -Name 'ActiveDirectorySubnet' -AddressPrefix '10.10.5.0/24'

# Create a virtual network
$ntiervnet = New-AzVirtualNetwork -Name 'frompsntier' -ResourceGroupName $resg.ResourceGroupName -Location $resg.Location -AddressPrefix '10.10.0.0/16' -Subnet $appgwsubnet,$webtiersubnet,$businesstiersubnet,$datatiersubnet,$managementtiersubnet,$adsubnet

