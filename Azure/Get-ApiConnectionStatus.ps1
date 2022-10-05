$resourcegroup = "DEVRG"
$resources = Get-AzResource -ResourceGroupName $resourcegroup -ResourceType 'Microsoft.Web/connections' -Name '*_azureblob'
foreach ($r in $resources) {
    $resource = Get-AzResource -ResourceId $r.ResourceId
    $statuses = $resource.Properties.statuses
    if ($statuses) {
        $statusError = $statuses[0].error
        if ($statusError -and $statusError.code -eq "Unauthenticated") {
            Write-Host $resource.Name is unauthenticated
        }
    }
}
