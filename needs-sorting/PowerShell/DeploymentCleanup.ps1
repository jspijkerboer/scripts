    if ($ErrorMessages) {
        Write-Output '', 'Template deployment returned the following errors:', @(@($ErrorMessages) | ForEach-Object { $_.Exception.Message.TrimEnd("`r`n") })
    }
       ##START ADDITION
       else
       {
             Write-Output '', 'Deployment completed without errors.'

             try{
                    # Clean older Deployments, to prevent hitting limit of 800.
                    [int]$DeplCount = ( Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName ).Count
                    Write-Output '', "$DeplCount old Deployments existing."

                    if( $DeplCount -gt 100 )
                    {
                          Write-Output '', 'Cleaning old Deployments.'

                          Get-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                          | Select-Object -Skip 100 -Last 25 `
                          | Remove-AzureRmResourceGroupDeployment

                          Write-Output '', 'Cleaning completed.'
                    }
             }
             catch{
                    Write-Output '', 'Cleaning encountred issues.'
             }
       }
       ##END ADDITION
