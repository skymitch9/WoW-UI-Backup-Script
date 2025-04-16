# Define path to config file
$configPath = "$PSScriptRoot\wowUI_config.json"

# Function to select folder
function Select-Folder {
    param ([string]$message)
    $folder = New-Object -ComObject Shell.Application | ForEach-Object { $_.BrowseForFolder(0, $message, 0).self.Path }
    return $folder
}

# Function to load config
function Load-Config {
    if (Test-Path $configPath) {
        return Get-Content $configPath | ConvertFrom-Json
    }
    return $null
}

# Function to save config
function Save-Config {
    param (
        [string]$parent,
        [string]$destination
    )
    $config = @{
        Parent = $parent
        Destination = $destination
    }
    $config | ConvertTo-Json | Set-Content -Path $configPath
}

# Load or prompt for config
$config = Load-Config
if (-not $config) {
    $parentFolder = Select-Folder -message "Select the folder that contains both 'Interface' and 'WTF'"
    $destinationFolder = Select-Folder -message "Select the destination folder for the backup"

    if (-not $parentFolder -or -not $destinationFolder) {
        Write-Output "Folder selection was canceled. Exiting script."
        exit
    }

    Save-Config -parent $parentFolder -destination $destinationFolder
} else {
    $parentFolder = $config.Parent
    $destinationFolder = $config.Destination
}

# Define full paths to Interface and WTF folders
$interfaceFolder = Join-Path $parentFolder "Interface"
$wtfFolder = Join-Path $parentFolder "WTF"

# Validate both folders exist
if (!(Test-Path $interfaceFolder) -or !(Test-Path $wtfFolder)) {
    Write-Output "Interface or WTF folder not found in: $parentFolder. Exiting."
    exit
}

# Create backup folder with timestamp
$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -Format "HHmm"
$newFolderName = "wowUI_${date}_$time"
$newDestinationFolder = "$destinationFolder\$newFolderName"

if (!(Test-Path $newDestinationFolder)) {
    New-Item -ItemType Directory -Path $newDestinationFolder
}

# Copy Interface and WTF folders
Copy-Item -Path $interfaceFolder -Destination "$newDestinationFolder\Interface" -Recurse
Copy-Item -Path $wtfFolder -Destination "$newDestinationFolder\WTF" -Recurse

# Zip it
$zipFile = "$destinationFolder\wowUI_Backup_${date}_$time.zip"
Compress-Archive -Path $newDestinationFolder -DestinationPath $zipFile -Force

# Clean up copied folders
Remove-Item $newDestinationFolder -Recurse -Force

Write-Output "Backup completed successfully. Zip saved to: $zipFile"

# Ask if user wants to schedule it (only if config was just created)
if (-not $config) {
    $setupScheduler = Read-Host "Do you want to schedule this backup to run automatically? (yes/no)"
    if ($setupScheduler -eq "yes") {
        $taskName = "WowUI_Backup"
        $scriptPath = $MyInvocation.MyCommand.Definition

        $scheduleFrequency = Read-Host "How often do you want to run the backup? (daily/weekly)"
        $scheduleTime = Read-Host "Enter the time for the task to run (e.g., 15:00)"

        if ($scheduleFrequency -eq "daily") {
            $trigger = New-ScheduledTaskTrigger -Daily -At $scheduleTime
        } elseif ($scheduleFrequency -eq "weekly") {
            $dayOfWeek = Read-Host "Enter the day of the week (e.g., Monday)"
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $dayOfWeek -At $scheduleTime
        } else {
            Write-Output "Invalid schedule frequency. Exiting."
            exit
        }

        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Automated backup for WowUI" -User $env:UserName -RunLevel Highest

        Write-Output "Scheduled task '$taskName' created."
    }
}
