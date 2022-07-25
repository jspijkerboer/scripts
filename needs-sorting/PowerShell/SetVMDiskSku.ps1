param (
    [Parameter(Mandatory)]
    [string]
    $resourcGroupName,
    [Parameter(Mandatory = $false)]
    [string]
    $targetSkuName = 'StandardSSD_LRS'
)
$ErrorActionPreference = 'Stop'

Write-Host 'Importing module Az ...'
Import-Module 'Az'
Write-Host 'Module Az imported.'

$targetSku = [Microsoft.Azure.Management.Compute.Models.DiskSku]::new($targetSkuName)
$skuName = @{label = 'Sku name'; expression = { $_.Sku.Name } }
Write-Host "Target SKU $($targetSku.Name)"

Write-Host 'Updating disk SKU ...'
$disks = Get-AzDisk -ResourceGroupName $resourcGroupName | Where-Object { $_.Name -NotLike '*buildDisk' }
foreach ($disk in $disks) {
    $disk.Sku = $targetSku
    (Update-AzDisk -ResourceGroupName $resourcGroupName -Disk $disk -DiskName $disk.Name) | Select-Object Name, $skuName
}
Write-Host 'Disk SKU updated.'
