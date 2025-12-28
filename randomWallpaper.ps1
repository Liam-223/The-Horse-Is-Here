# randomly switch between two wallpapers every 1–10 minutes (Windows 11, idk if it works for others)

# 3-16 minutes (in seconds)
$minTime = 180
$maxTime = 960
$startAfter = 5

$scriptDir = Split-Path -Parent $PSCommandPath
$assetsDir = Join-Path $scriptDir 'assets'

$images = @(
    (Join-Path $assetsDir 'version1.png'),
    (Join-Path $assetsDir 'version2.png'),
    (Join-Path $assetsDir 'version3.png')
)

$images = $images | Where-Object { Test-Path $_ }
if ($images.Count -lt 2) {
    throw "Need at least 2 existing images in '$assetsDir'. Found: $($images.Count)."
}


# ---- Wallpaper style ----
Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name WallpaperStyle -Value "10"
Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name TileWallpaper   -Value "0"

# ---- WinAPI wrapper to set the wallpaper ----
Add-Type @"
using System.Runtime.InteropServices;
public static class WinWallpaper {
  [DllImport("user32.dll", SetLastError=true, CharSet=CharSet.Auto)]
  public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

function Set-Wallpaper($path) {
    Set-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name wallpaper -Value $path | Out-Null
    [WinWallpaper]::SystemParametersInfo(20, 0, $path, 0x01 -bor 0x02) | Out-Null
}

# ---- Audio ----
$global:SoundPlayer = $null
try {
    $global:SoundPlayer = [System.Media.SoundPlayer]::new()
} catch {
    $global:SoundPlayer = $null  # couldnt create the player so audio will just be skipped to prevent some breaking
}

function Play-AudioForImage($imagePath) {
    if (-not $global:SoundPlayer) {
        return   # audio not available, do nothing
    }

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($imagePath)
    $dir      = [System.IO.Path]::GetDirectoryName($imagePath)

    $candidate = Join-Path $dir ($baseName + '.wav')
    if (Test-Path $candidate) {
        try {
            $global:SoundPlayer.Stop()
            $global:SoundPlayer.SoundLocation = $candidate
            $global:SoundPlayer.Load()
            $global:SoundPlayer.Play()
        } catch {
            # if playing fails, just ignore
        }
    }
}


# ---- Main loop ----
try {
    $initialWallpaper = (Get-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name wallpaper).wallpaper
} catch {
    $initialWallpaper = $null
} # check so we dont repeat ourselfs

$previousImage = $initialWallpaper


Start-Sleep -Seconds $startAfter
while ($true) {
    # pick a random image different from the previous one
    do {
        $next = Get-Random -InputObject $images
    } while ($previousImage -and ([string]::Compare($previousImage, $next, $true) -eq 0))

    Set-Wallpaper $next
    Play-AudioForImage $next

    $previousImage = $next

    $delay = Get-Random -Minimum $minTime -Maximum $maxTime
    Start-Sleep -Seconds $delay
}