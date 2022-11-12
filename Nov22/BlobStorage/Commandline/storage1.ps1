$resg_name = 'storage1'
$location = 'eastus'
Write-Host "Creating a resource group with name $resg_name in $location"
$resg = New-AzResourceGroup -Name $resg_name -Location $location
Write-Host "Created a resource group with name $resg_name in $location"

$mystorageaccount = New-AzStorageAccount `
    -ResourceGroupName $resg_name `
    -Name 'qtstorfromps1' -Location $location `
    -SkuName Standard_RAGRS

# Create a storage account context
$ctx = New-AzStorageContext -StorageAccountName $mystorageaccount.StorageAccountName -UseConnectedAccount

# Create storage container called as images


$images_container = New-AzStorageContainer -Name 'images' `
    -Permission Off -Context $ctx


#Remove-AzResourceGroup -Name $resg_name -Force
New-Item 1.txt 
New-Item 2.txt

$Blob1HT = @{
    File             = '1.txt'
    Container        = $images_container.Name
    Blob             = '1.txt'
    Context          = $mystorageaccount.Context
    StandardBlobTier = 'Hot'
}

Set-AzStorageBlobContent @Blob1HT

$Blob2HT = @{
    File             = '2.txt'
    Container        = $images_container.Name
    Blob             = '2.txt'
    Context          = $mystorageaccount.Context
    StandardBlobTier = 'Hot'
}

Set-AzStorageBlobContent @Blob2HT
$storageaccountname = $mystorageaccount.StorageAccountName
$images_container_name = $images_container.Name
$sourceDir = "C:\Classroomnotes\Azure\Apr20\Datbases\Images"
$endpoint = "https://$storageaccountname.blob.core.windows.net/$images_container_name"
azcopy copy $sourceDir $endpoint