# Create a New Resource Group
$resg = New-AzResourceGroup -Name 'fromps' -Location 'eastus'

# Create a Storage Account
$storageacc = New-AzStorageAccount -Name 'qtstoragedemo1'  -ResourceGroupName $resg.ResourceGroupName -Location $resg.Location -Kind 'StorageV2' -SkuName 'Standard_ZRS' -AccessTier 'Hot' -AllowBlobPublicAccess $true

# Create a Storage Account Container for music
$container = New-AzStorageContainer -Name 'music' -Permission Blob -Context $storageacc.Context

$videoscontainer = New-AzStorageContainer -Name 'videos' -Permission Blob -Context $storageacc.Context

$docscontainer = New-AzStorageContainer -Name 'docs' -Permission Blob -Context $storageacc.Context

# Upload blobs
Set-AzStorageBlobContent -File .\demo.txt -Container $docscontainer.Name -Blob 'demo.txt' -Context $storageacc.Context

Set-AzStorageBlobContent -File ".\authenticationandauthorization.mp4" -Container $videoscontainer.Name -Context $storageacc.Context -Blob 'auth.mp4'

## List the Blobs
Get-AzStorageBlob -Container $videoscontainer.Name -Context $storageacc.Context