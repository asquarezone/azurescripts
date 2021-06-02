# Create a Resource Group
$resg = New-AzResourceGroup -Name 'storageaccps' -Location 'eastus'

#Create a Storage account
$storageAccount = New-AzStorageAccount -ResourceGroupName $resg.ResourceGroupName `
           -Name 'qtstorpsdemo' -SkuName 'Standard_RAGRS' -Location $resg.Location

# Create a Context Object
$context = $storageAccount.Context

$imagesContainer = New-AzStorageContainer -Name 'images' -Context $context -Permission 'Blob'

# Upload a file from Downloads folder to the Hot access tier
Set-AzStorageBlobContent -File 'C:\Users\qtkha\Downloads\content.txt' `
  -Container 'images' `
  -Blob 'content.txt' `
  -Context $context `
  -StandardBlobTier Hot `
