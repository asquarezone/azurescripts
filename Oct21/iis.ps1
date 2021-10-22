$resg = New-AzResourceGroup -Name 'psdemo' -Location 'eastus'

$vm = New-AzVM `
        -ResourceGroupName $resg.ResourceGroupName `
        -Name 'mywinvm' `
        -Location $resg.Location -VirtualNetworkName "myvnet" `
        -SubnetName "mysubnet" -SecurityGroupName "mynsg" `
        -PublicIpAddressName 'mypip' -OpenPorts 80,3389 `
        -Size 'Standard_B1s'