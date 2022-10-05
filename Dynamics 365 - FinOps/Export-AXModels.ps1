Set-Location $(NuGetsPath)\\$(ToolsPackage) 

$models = Get-ChildItem $(MetadataPath) | Where-Object {$_.Name -ne "ExcludeModels"}
$buildnumberForFile = "$(Build.BuildNumber)" 

foreach ($model in $models)
{
    Write-Host "Exporting $model"
    $descriptorpath = Join-Path -path $($model.fullName) -ChildPath "Descriptor"
 
    if (test-path -path $descriptorpath) {
        $descriptorFiles = @(Get-ChildItem -Path $descriptorpath -file -filter "*.xml")
        if ($descriptorFiles.Count -gt 0)
        {
            foreach ($descriptorFile in $descriptorFiles)
            {
                $modelName = $descriptorFile.BaseName
                .\modelutil.exe -export -metadatastorepath=$(MetadataPath) -modelname="$modelName" -outputpath=$(Build.ArtifactStagingDirectory)
                $newFileName = $($model.name + "_axmodelsource_" + $buildnumberForFile + ".axmodel")
                Get-ChildItem $(Build.ArtifactStagingDirectory) -filter "$modelName*.axmodel" | rename-item -newname $newFileName
            }
        }
    }
}