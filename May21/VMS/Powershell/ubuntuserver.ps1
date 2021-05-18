# Create a resource group
$resourceGroup = New-AzResourceGroup -Name 'vmfromps' -Location 'eastus'

# Create a virtual network and subnet
$websubnet = New-AzVirtualNetworkSubnetConfig -Name 'websubnet' -AddressPrefix '192.168.0.0/24'

$dbsubnet = New-AzVirtualNetworkSubnetConfig -Name 'dbsubnet' -AddressPrefix '192.168.1.0/24'

$vnet = New-AzVirtualNetwork -Name ntier -ResourceGroupName $resourceGroup.ResourceGroupName -Location $resourceGroup.Location -AddressPrefix '192.168.0.0/16' -Subnet $websubnet,$dbsubnet

# Create a Public ip address
$publicIp = New-AzPublicIpAddress -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location -AllocationMethod 'Dynamic' -Name 'mypublicip'

# Creating Network Security 
$rule1 = New-AzNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow SSH" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22

$rule2 = New-AzNetworkSecurityRuleConfig -Name web-rule -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 -SourceAddressPrefix `
    Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location  -Name `
    "NSG-FrontEnd" -SecurityRules $rule1,$rule2

$SecurePassword = ConvertTo-SecureString "qtdevops@123" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ("qtdevops", $SecurePassword);

$vm = New-AzVM -Credential $Credential -ResourceGroupName $resourceGroup.ResourceGroupName `
    -Location $resourceGroup.Location -SubnetName $vnet.Subnets[0].Name -VirtualNetworkName $vnet.Name`
    -PublicIpAddressName $publicIp.Name -Image 'UbuntuLTS' -OpenPorts 22,80  -Size "Standard_B1s" `
    -Name "qtlinuxvm"


    