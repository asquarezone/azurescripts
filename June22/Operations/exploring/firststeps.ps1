# Creating the resource group
$resg = New-AzResourceGroup -Name 'fromps' -Location 'centralus'
Write-Host "$($resg.ResourceGroupName) is Created in Region $($resg.Location)"


#Deleting the Resource Group
Remove-AzResourceGroup -Name $resg.ResourceGroupName -Confirm