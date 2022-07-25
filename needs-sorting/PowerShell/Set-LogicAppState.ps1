param([string] $subscriptioname, [string] $resourcegroup, [ValidateSet("Enabled", "Disabled")][string]$state)

$logicapps =
'CustomerSend',
'CustomerSend_2'

Get-AzureRmSubscription -SubscriptionName $subscriptioname | Select-AzureRmSubscription
$logicapps | ForEach-Object {
    $RmLogicApp = Get-AzureRmLogicApp -ResourceGroupName $resourcegroup -Name $_  -ErrorAction SilentlyContinue
    if ($RmLogicApp -ne $null)
    {
        Set-AzureRmLogicApp -ResourceGroupName $resourcegroup -Name $RmLogicApp.Name -State $state -Force | Format-List -Property Name, State, ChangedTime
    }
    else
    {
        Write-Warning "Logic app $_ not found."
    }
}
