$AzureSubscriptionId       = ''
$ResourceGroupName               = 'interfaces'
$StorageAccountName              = 'interfacestorage'

Function AvaCreateAzureTable( [string]$tableName )
{
    $AzTable = Get-AzureStorageTable -Name $tableName -Context $context -ErrorAction SilentlyContinue

    if( $AzTable )
    {
        Write-Host "Table does already exist: $tableName"
    }
    else
    {
        New-AzureStorageTable –Name $tableName –Context $context -ErrorAction SilentlyContinue | Out-Null
        Write-Host "Sucessfully created table: $tableName" -ForegroundColor Green
    }
}
Catch {
    Write-Host "Error: Failed creating table: $tableName" -ForegroundColor Red
}

Clear-Host

# log in
if( $LoggedIn -eq $false )
{
       Login-AzureRmAccount -Subscription $AzureSubscriptionId
       $context = (Get-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName).Context
       $LoggedIn = $true
}

#Create tables
if( $true )
{
    AvaCreateAzureTable( 'table' )
    AvaCreateAzureTable( 'table2' )
}
