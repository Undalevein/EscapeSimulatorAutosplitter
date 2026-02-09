$folder = "$PSScriptRoot\bin"

if (-not (Test-Path -path $folder)) {
    New-Item -Path $folder -ItemType Directory
}

Remove-Item -Path "$folder\*.*"

$accepted = @(".asl")
$files = Get-ChildItem -Path $PSScriptRoot | Where-Object {$_.extension -in $accepted}

foreach ($file in $files) {
    Compress-Archive -LiteralPath "$PSScriptRoot\$($file.Name)" -DestinationPath "$folder\$($file.Name)".replace(".asl", ".zip")
}

"[$(Get-Date)]: ASL files have been zipped and placed in the bin folder."