$ResourceGroupName = 'DEVRG'
$IntegrationAccountName = 'IntegrationAccount'

$DefaultWorkingDirectory = '.'
Get-ChildItem $DefaultWorkingDirectory -Recurse | Where-Object {$_.Name -like '*.xslt'} | ForEach-Object {

    $MapFilePath = $_.FullName
    $MapName = [System.IO.Path]::GetFileNameWithoutExtension($MapFilePath)

    Write-Host "Name: $MapName"
    Write-Host "Path: $MapFilePath"

    $IntegrationAccountMap = Get-AzureRmIntegrationAccountMap -ResourceGroupName $ResourceGroupName -Name $IntegrationAccountName  | Where-Object{$_.Name -match $MapName}
    if ($IntegrationAccountMap)
    {
        Write-Host "Action: Update map"
        Set-AzureRmIntegrationAccountMap -ResourceGroupName $ResourceGroupName -Name $IntegrationAccountName -MapName $MapName -MapFilePath $MapFilePath -Force
    }
    else
    {
        Write-Host "Action: Create map"
        New-AzureRmIntegrationAccountMap -ResourceGroupName $ResourceGroupName -Name $IntegrationAccountName -MapName $MapName -MapFilePath $MapFilePath
    }
}