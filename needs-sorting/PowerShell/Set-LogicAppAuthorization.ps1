param([string][Parameter(Mandatory=$true)][ValidateSet("DEVRG", "TSTRG", "ACCRG", "PRDRG")] $resourcegroup)

# Below line will allow PowerShell to run scripts
set-executionpolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

#region mini window, made by Scripting Guy Blog
Function Show-OAuthWindow
{
    Add-Type -AssemblyName System.Windows.Forms

    $form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=600;Height=800}
    $web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=580;Height=780;Url=($url -f ($Scope -join "%20")) }
    $DocComp  = {
            $Global:uri = $web.Url.AbsoluteUri
            if ($Global:Uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
    }
    $web.ScriptErrorsSuppressed = $true
    $web.Add_DocumentCompleted($DocComp)
    $form.Controls.Add($web)
    $form.Add_Shown({$form.Activate()})
    $form.ShowDialog() | Out-Null
}
#endregion

function Authenticate-Connections()
{
    Write-Verbose "Authenticating..."

    $parameters = @{
	    "parameters" = ,@{
	    "parameterName"= "token";
	    "redirectUrl"= "https://ema1.exp.azure.com/ema/default/authredirect"
	    }
    }

    $regex = '(code=)(.*)$'

    foreach ($resource in $oathconnections)
    {
        $consentResponse = Invoke-AzureRmResourceAction -Action "listConsentLinks" -ResourceId $resource.ResourceId -Parameters $parameters -Force

        $url = $consentResponse.Value.Link

        #prompt user to login and grab the code after auth
        Show-OAuthWindow -URL $url

        $code  = ($uri | Select-string -pattern $regex).Matches[0].Groups[2].Value

        if (-Not [string]::IsNullOrEmpty($code))
        {
	        $parametersCode = @{ }
	        $parametersCode.Add("code", $code)

	        Invoke-AzureRmResourceAction -Action "confirmConsentCode" -ResourceId $resource.ResourceId -Parameters $parametersCode -Force -ErrorAction Ignore
        }
        Write-Host "Authenticated" $Resource.Name
    }
}

try
{
    Login-AzureRmAccount -TenantId hnlitechazureheineken.onmicrosoft.com

    $oathconnections = Get-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/connections -Name *_dynamicsax
    Authenticate-Connections

    $oathconnections = Get-AzureRmResource -ResourceGroupName $resourcegroup -ResourceType Microsoft.Web/connections -Name *_office365
    Authenticate-Connections
}
catch [System.Exception]
{
    Write-Error "Exception thrown at $($_.InvocationInfo.ScriptName):$($_.InvocationInfo.ScriptLineNumber): $($_.InvocationInfo.Line.Trim())$([Environment]::NewLine)$($_.Exception.ToString())"
}
