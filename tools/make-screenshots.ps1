# Makes clean, web-sized screenshots for the README and Nexus page.
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\tools\make-screenshots.ps1 `
#     -Inventory100 <path> -Inventory80 <path> -Inventory60 <path> -Crafting60 <path>
#
# Output: docs\screenshots\*.jpg
# The comparison image is 2560 x 760; the individual images are 1920 x 1080.

param(
    [Parameter(Mandatory = $true)] [string] $Inventory100,
    [Parameter(Mandatory = $true)] [string] $Inventory80,
    [Parameter(Mandatory = $true)] [string] $Inventory60,
    [Parameter(Mandatory = $true)] [string] $Crafting60,
    [string] $OutDir = ""
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

if (-not $OutDir) {
    $OutDir = Join-Path $PSScriptRoot "..\docs\screenshots"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
    Where-Object { $_.MimeType -eq "image/jpeg" } |
    Select-Object -First 1

if (-not $jpegCodec) {
    throw "No JPEG encoder found."
}

function Save-Jpeg {
    param(
        [System.Drawing.Bitmap] $Bitmap,
        [string] $Path,
        [long] $Quality = 90
    )

    $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
        [System.Drawing.Imaging.Encoder]::Quality,
        $Quality
    )
    try {
        $Bitmap.Save($Path, $jpegCodec, $encoderParams)
    }
    finally {
        $encoderParams.Dispose()
    }
}

function Resize-Image {
    param(
        [string] $Source,
        [string] $Destination,
        [int] $Width,
        [int] $Height
    )

    if (-not (Test-Path $Source)) {
        throw "Missing screenshot: $Source"
    }

    $image = [System.Drawing.Image]::FromFile($Source)
    $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
        $graphics.DrawImage($image, 0, 0, $Width, $Height)
        Save-Jpeg -Bitmap $bitmap -Path $Destination
    }
    finally {
        $graphics.Dispose()
        $bitmap.Dispose()
        $image.Dispose()
    }
}

function New-Comparison {
    param(
        [string] $LeftSource,
        [string] $RightSource,
        [string] $Destination
    )

    $cellWidth = 1280
    $cellHeight = 720
    $labelHeight = 40
    $canvasWidth = $cellWidth * 2
    $canvasHeight = $cellHeight + $labelHeight

    $left = [System.Drawing.Image]::FromFile($LeftSource)
    $right = [System.Drawing.Image]::FromFile($RightSource)
    $canvas = New-Object System.Drawing.Bitmap($canvasWidth, $canvasHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($canvas)
    $font = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
    $white = [System.Drawing.Brushes]::White
    $divider = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 70, 70, 70), 2)

    try {
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

        $graphics.Clear([System.Drawing.Color]::FromArgb(255, 18, 18, 18))
        $graphics.DrawImage($left, 0, $labelHeight, $cellWidth, $cellHeight)
        $graphics.DrawImage($right, $cellWidth, $labelHeight, $cellWidth, $cellHeight)
        $graphics.DrawLine($divider, $cellWidth, $labelHeight, $cellWidth, $canvasHeight)

        $leftText = "100%"
        $rightText = "80%"
        $leftSize = $graphics.MeasureString($leftText, $font)
        $rightSize = $graphics.MeasureString($rightText, $font)
        $graphics.DrawString($leftText, $font, $white, ($cellWidth - $leftSize.Width) / 2, ($labelHeight - $leftSize.Height) / 2)
        $graphics.DrawString($rightText, $font, $white, ($cellWidth * 1.5) - ($rightSize.Width / 2), ($labelHeight - $rightSize.Height) / 2)

        Save-Jpeg -Bitmap $canvas -Path $Destination -Quality 92
    }
    finally {
        $divider.Dispose()
        $font.Dispose()
        $graphics.Dispose()
        $canvas.Dispose()
        $right.Dispose()
        $left.Dispose()
    }
}

Resize-Image -Source $Inventory100 -Destination (Join-Path $OutDir "01-inventory-100.jpg") -Width 1920 -Height 1080
Resize-Image -Source $Inventory80  -Destination (Join-Path $OutDir "02-inventory-80.jpg")  -Width 1920 -Height 1080
Resize-Image -Source $Inventory60 -Destination (Join-Path $OutDir "03-inventory-60.jpg") -Width 1920 -Height 1080
Resize-Image -Source $Crafting60  -Destination (Join-Path $OutDir "04-crafting-60.jpg")  -Width 1920 -Height 1080

New-Comparison -LeftSource $Inventory100 -RightSource $Inventory80 -Destination (Join-Path $OutDir "00-comparison-inventory-100-80.jpg")

Get-ChildItem $OutDir -Filter *.jpg | Sort-Object Name | Select-Object Name, Length
