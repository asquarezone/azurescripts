$rgname = "sqlfromps"
$location = "eastus"

$servername = "qtsqlserverps"

$startIp = "0.0.0.0"
$endIp = "255.255.255.255"

$databaseName = 'qtecommerce'

Write-Host "Creating Resource Group"
$rg = New-AzResourceGroup -Name $rgname -Location $location

Write-Host "Creating SQL Server"
$server = New-AzSqlServer -ServerName $servername -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -SqlAdministratorCredentials (Get-Credential)


$firewallRule = New-AzSqlServerFirewallRule -ResourceGroupName $rg.ResourceGroupName `
    -ServerName $server.ServerName -FirewallRuleName 'Allow ALL'`
    -StartIpAddress $startIp -EndIpAddress $endIp

$database = New-AzSqlDatabase -ResourceGroupName $rg.ResourceGroupName -ServerName $server.ServerName `
    -Edition "GeneralPurpose" -DatabaseName $databaseName -VCore 1 -ComputeGeneration "Gen5" `
    -ComputeModel "Serverless"

