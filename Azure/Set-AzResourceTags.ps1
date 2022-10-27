[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $resourceGroupName
)

$resourceGroupTags = (Get-AzResourceGroup -Name $resourceGroupName).Tags
$resources = (Get-AzResource -ResourceGroupName $resourceGroupName)

$resourceTags = @{}
($resourceGroupTags.GetEnumerator()) | Where-Object { ($_.Key -eq 'source') -or ($_.Key -eq 'environment') } | ForEach-Object { $resourceTags.Add($_.Key, $_.Value) }

foreach ($resource in $resources) {
    Write-Host "Merging tags on $($resource.ResourceType) - $($resource.ResourceName)"
    Update-AzTag -ResourceId $resource.Id -Tag $resourceTags -Operation Merge | Out-Null
}