$SourceArchivePath = "C:\Temp\source.zip"
$FileMatchCSV = "C:\Temp\filenamefilter.csv"
$OutputPath = "C:\Temp\extract\"
$TargetArchivePath = "C:\Temp\extract\target.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($SourceArchivePath)

$filelist = Import-Csv $FileMatchCSV -Delimiter ";"
$zip.Entries | Where-Object { $_.Name -In $filelist.filename} | ForEach-Object {
    $FileName = $_.Name
    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$OutputPath\$FileName", $true)
}

$zip.Dispose()

Compress-Archive -Path $OutputPath -DestinationPath $TargetArchivePath