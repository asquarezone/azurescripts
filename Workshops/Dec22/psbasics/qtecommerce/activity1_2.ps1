
$tags = @{Environment="Dev"}
$tags += @{Project="azurelearning"}
$tags += @{Release="v1.1"}
$tags += @{Team="qtazure"}
$tags += @{From="powershell"}

Get-AzResource -ResourceGroupName 'activity1' | foreach { Set-AzResource -ResourceGroupName $_.ResourceGroupName -Name $_.Name `
    -ResourceType $_.ResourceType -Tag $tags -Force}