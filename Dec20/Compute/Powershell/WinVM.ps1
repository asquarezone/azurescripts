# Lets Create a Resource Group
$location = "eastus"
$rg_name  = "fromps"
$rg = New-AzResourceGroup -Name $rg_name -Location $location
$publisher = 'MicrosoftWindowsServer'
$offer = "WindowsServer"
$vmsku = '2016-Datacenter'
$imageversion = '2016.127.20190416'
$vm_name = 'winvmfromps'
$vnet_name = 'forps'
$subnet_name = 'web'
$ports_to_be_opened = 3389,80,443
$vmImage = Get-AzVMImage -PublisherName $publisher -Offer $offer -Skus $vmsku -Location $location -Version $imageversion 
$vm = New-AzVM -ResourceGroupName $rg_name -Location $location -Name $vm_name -Credential (Get-Credential) -VirtualNetworkName $vnet_name -SubnetName $subnet_name -PublicIpAddressName 'winpubip' -OpenPorts ports_to_be_opened -Image 'Win2016Datacenter' -Size 'Standard_B1s'

