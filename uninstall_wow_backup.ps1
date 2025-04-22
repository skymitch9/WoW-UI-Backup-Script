# Prompt for elevation if not already admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Restarting with administrative privileges..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "Uninstalling WoW UI Backup setup..."

# Remove Scheduled Task
$taskName = "WowUI_Backup"
if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "✅ Scheduled task '$taskName' removed."
} else {
    Write-Host "ℹ️ No scheduled task named '$taskName' found."
}

# Remove Config File
$configPath = Join-Path $PSScriptRoot "wowUI_config.json"
if (Test-Path $configPath) {
    Remove-Item $configPath -Force
    Write-Host "✅ Config file removed: $configPath"
} else {
    Write-Host "ℹ️ No config file found at: $configPath"
}

Write-Host "`n✅ Uninstall complete. Press any key to close..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
