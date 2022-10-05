<# Prepare-D365DevelopmentMachine
 #
 # Preparation:
 # So that the installations do not step on each other: First run windows updates, also
 # wait for antimalware to run scan...otherwise this will take a long time and we do not
 # want an automatic reboot to occur while this script is executing.
 #
 # Execute this script:
 # Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('http://192.166.1.15:8000/Prepare-D365DevelopmentMachine.ps1'))
 #
 # Tested on Windows 10 and Windows Server 2016
 # Tested on F&O 7.3 OneBox and F&O 8.1 OneBox and a 10.0.11 Azure Cloud Hosted Environment (CHE) deployed from LCS
 #
 # Ideas:
 #  Download useful SQL and PowerShell scripts, using Git?
 #>

#region Install additional apps using Chocolatey

If (Test-Path -Path "$env:ProgramData\Chocolatey") {
    choco upgrade chocolatey -y -r
    choco upgrade all --ignore-checksums -y -r
}
Else {

    Write-Host “Installing Chocolatey”
 
    [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    #Determine choco executable location
    #   This is needed because the path variable is not updated
    #   This part is copied from https://chocolatey.org/install.ps1
    $chocoPath = [Environment]::GetEnvironmentVariable("ChocolateyInstall")
    if ($chocoPath -eq $null -or $chocoPath -eq '') {
        $chocoPath = "$env:ALLUSERSPROFILE\Chocolatey"
    }
    if (!(Test-Path ($chocoPath))) {
        $chocoPath = "$env:SYSTEMDRIVE\ProgramData\Chocolatey"
    }
    $chocoExePath = Join-Path $chocoPath 'bin\choco.exe'

    $packages = @(
        "powershell-core"
        "azcopy10"
        "azurepowershell"
        "azure-data-studio"
        "vscode"
        "microsoft-edge"
        "sql-server-management-studio"
    )

    # Install each program
    foreach ($packageToInstall in $packages) {

        Write-Host “Installing $packageToInstall” -ForegroundColor Green
        & $chocoExePath "install" $packageToInstall "-y" "-r"
    }
}
 
#endregion


#region Installing d365fo.tools

# This is requried by Find-Module, by doing it beforehand we remove some warning messages
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Installing d365fo.tools
If ($null -eq (Find-Module -Name d365fo.tools).InstalledDate) {
    Write-Host "Installing d365fo.tools"
    Write-Host "Documentation: https://github.com/d365collaborative/d365fo.tools"
    Install-Module -Name d365fo.tools -SkipPublisherCheck -Scope AllUsers
}
else {
    Write-Host "Updating d365fo.tools"
    Update-Module -name d365fo.tools -SkipPublisherCheck -Scope AllUsers
}

Write-Host "Setting Windows Defender rules to speed up compilation time"
Add-D365WindowsDefenderRules -Silent

#endregion