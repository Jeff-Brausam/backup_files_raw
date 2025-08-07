# Define your source and destination correctly
$SourcePath = "<Enter your Source Path Here>"
$BackupPath = "<Enter your Backup Path Here>"

# Get all files recursively
$files = Get-ChildItem -Path $SourcePath -Recurse -File

foreach ($file in $files) {
    $relativePath = $file.FullName.Substring($SourcePath.Length).TrimStart('\')

    $DestinationFile = Join-Path $BackupPath $relativePath

    $DestinationFolder = Split-Path $DestinationFile -Parent
    if (-not (Test-Path $DestinationFolder)) {
        New-Item -Path $DestinationFolder -ItemType Directory -Force | Out-Null
    }

    $existingFile = Get-Item -Path $DestinationFile -ErrorAction SilentlyContinue

    if (!$existingFile -or $existingFile.LastWriteTime -lt $file.LastWriteTime) {
        Copy-Item -Path $file.FullName -Destination $DestinationFile -Force
    } else {
        Write-Host "Most current file exists, no backup needed."
    }
}
