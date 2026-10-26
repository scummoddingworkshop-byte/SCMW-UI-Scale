# Builds the player release zip for SCMW - UI Scale.
# Usage: powershell -ExecutionPolicy Bypass -File .\build.ps1

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
$source = Join-Path $root "src\SCMW_UIScale"
$scriptPath = Join-Path $source "Scripts\main.lua"
$readmePath = Join-Path $source "README.txt"
$licensePath = Join-Path $source "LICENSE.txt"
$dist = Join-Path $root "dist"

if (-not (Test-Path $scriptPath)) {
    throw "Missing mod script: $scriptPath"
}
if (-not (Test-Path $readmePath)) {
    throw "Missing mod readme: $readmePath"
}
if (-not (Test-Path $licensePath)) {
    throw "Missing mod licence: $licensePath"
}

$versionLine = Select-String -Path $scriptPath -Pattern 'local MOD_VERSION = "([^"]+)"' | Select-Object -First 1
if (-not $versionLine) {
    throw "Could not find MOD_VERSION in $scriptPath"
}
$version = $versionLine.Matches[0].Groups[1].Value

New-Item -ItemType Directory -Force -Path $dist | Out-Null

$zipPath = Join-Path $dist "SCMW_UIScale_v$version.zip"
if (Test-Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$entriesToWrite = @(
    @{ Path = $scriptPath; Name = "ue4ss/Mods/SCMW_UIScale/Scripts/main.lua" },
    @{ Path = $readmePath; Name = "ue4ss/Mods/SCMW_UIScale/README.txt" },
    @{ Path = $licensePath; Name = "ue4ss/Mods/SCMW_UIScale/LICENSE.txt" }
)

$zipStream = [System.IO.File]::Open($zipPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::ReadWrite)
$archive = New-Object System.IO.Compression.ZipArchive($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($item in $entriesToWrite) {
        $entry = $archive.CreateEntry($item.Name, [System.IO.Compression.CompressionLevel]::Optimal)
        $entryStream = $entry.Open()
        try {
            $fileStream = [System.IO.File]::OpenRead($item.Path)
            try {
                $fileStream.CopyTo($entryStream)
            }
            finally {
                $fileStream.Dispose()
            }
        }
        finally {
            $entryStream.Dispose()
        }
    }
}
finally {
    $archive.Dispose()
    $zipStream.Dispose()
}

$archive = [System.IO.Compression.ZipFile]::OpenRead($zipPath)
try {
    $entries = $archive.Entries | ForEach-Object { $_.FullName }
}
finally {
    $archive.Dispose()
}

$required = @(
    "ue4ss/Mods/SCMW_UIScale/Scripts/main.lua",
    "ue4ss/Mods/SCMW_UIScale/README.txt",
    "ue4ss/Mods/SCMW_UIScale/LICENSE.txt"
)

foreach ($name in $required) {
    if ($entries -notcontains $name) {
        throw "Release zip is missing: $name"
    }
}

$hash = (Get-FileHash -Path $zipPath -Algorithm SHA256).Hash
$hashPath = Join-Path $dist "SCMW_UIScale_v$version.sha256.txt"
"$hash  SCMW_UIScale_v$version.zip" | Set-Content -Path $hashPath -Encoding ASCII

Write-Host ""
Write-Host "Built: $zipPath"
Write-Host ("Size:  {0:N0} bytes" -f (Get-Item $zipPath).Length)
Write-Host "SHA256: $hash"
Write-Host "Version: $version"
Write-Host "Contents:"
$entries | ForEach-Object { Write-Host "  $_" }
