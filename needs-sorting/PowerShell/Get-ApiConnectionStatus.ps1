$resourcegroup = "DEVRG"
$resources = Get-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/connections -Name *_dynamicsax
foreach ($r in $resources)
{
    $resource = Get-AzureRmResource -ResourceId $r.ResourceId
    $statuses = $resource.Properties.statuses
    if ($statuses)
    {
        $statusError = $statuses[0].error
        if ($statusError -and $statusError.code -eq "Unauthenticated")
        {
            Write-Host $resource.Name is unauthenticated
        }
    }
}
