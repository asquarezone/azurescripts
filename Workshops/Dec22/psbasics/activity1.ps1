$all_resorces_in_group = Get-AzResource -ResourceGroupName 'activity1'

$tags = @{Environment="Dev"}
$tags += @{Project="azurelearning"}
$tags += @{Release="v1.1"}
$tags += @{Team="qtazure"}

foreach ($resource in $all_resorces_in_group) {
    Set-AzResource -ResourceGroupName $resource.ResourceGroupName -Name $resource.Name `
        -ResourceType $resource.ResourceType -Tag $tags
}