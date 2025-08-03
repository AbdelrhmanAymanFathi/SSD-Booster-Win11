<#
.SYNOPSIS
Boosts performance of Windows 11 (24H2) on SATA SSD

.DESCRIPTION
- Enables TRIM
- Optimizes SSD
- Disables SysMain and Windows Search
- Sets power plan to High Performance
- Disables hibernation
- Suggests enabling write caching manually
- Disables visual effects (via system properties)
#>

# Requires Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "⚠️ Please run this script as Administrator."
    exit
}

Write-Host "🚀 Boosting SSD Performance..." -ForegroundColor Cyan

# 1. Enable TRIM (if not already enabled)
Write-Host "✅ Enabling TRIM..."
fsutil behavior set DisableDeleteNotify 0

# 2. Re-trim & Optimize SSD
Write-Host "🔧 Running TRIM and Optimize..."
Optimize-Volume -DriveLetter C -ReTrim -Verbose
Optimize-Volume -DriveLetter C -Defrag -Verbose

# 3. Disable SysMain
Write-Host "🧠 Disabling SysMain (Superfetch)..."
Stop-Service -Name SysMain -Force -ErrorAction SilentlyContinue
Set-Service  -Name SysMain -StartupType Disabled

# 4. Disable Windows Search
Write-Host "🔍 Disabling Windows Search Indexing..."
Stop-Service -Name WSearch -Force -ErrorAction SilentlyContinue
Set-Service  -Name WSearch -StartupType Disabled

# 5. Turn off hibernation
Write-Host "💤 Disabling Hibernation..."
powercfg -h off

# 6. Set High Performance power plan
Write-Host "⚡ Setting High Performance power plan..."
powercfg -setactive SCHEME_MIN

# 7. Prompt to enable write caching manually
Write-Host "`nℹ️ Please make sure 'Write caching' is enabled manually:"
Write-Host "   Device Manager > Disk Drives > SSD > Properties > Policies > Enable write caching"
Start-Sleep -Seconds 2

# 8. Open system performance settings for visual effect tweak
Write-Host "`n🖼️ Opening Visual Effects Settings (choose 'Adjust for best performance')..."
Start-Process "SystemPropertiesPerformance.exe"

Write-Host "`n✅ SSD Boosting Completed. Restart is recommended." -ForegroundColor Green

