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
        [string]$destination,
        [bool]$scheduled = $false
    )
    $newConfig = @{
        Parent      = $parent
        Destination = $destination
        Scheduled   = $scheduled
    }
    $newConfig | ConvertTo-Json | Set-Content -Path $configPath
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

    Save-Config -parent $parentFolder -destination $destinationFolder -scheduled $false
    $config = Load-Config
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

# Ask if user wants to schedule it (only if not already scheduled)
if (-not $config.Scheduled) {
    $setupScheduler = Read-Host "Do you want to schedule this backup to run automatically? (yes/no)"
    if ($setupScheduler -eq "yes") {
        $taskName = "WowUI_Backup"
        $scriptPath = $MyInvocation.MyCommand.Definition

        try {
            # Prompt for frequency with basic validation loop
            $scheduleFrequency = ""
            while ($scheduleFrequency -notin @("daily", "weekly")) {
                $scheduleFrequency = Read-Host "How often do you want to run the backup? (daily/weekly)"
                if ($scheduleFrequency -notin @("daily", "weekly")) {
                    Write-Host "Invalid input. Please type 'daily' or 'weekly'."
                }
            }
        
            # Prompt for time
            $scheduleTime = ""
            while ($scheduleTime -notmatch "^\d{1,2}:\d{2}$") {
                $scheduleTime = Read-Host "Enter the time for the task to run (e.g., 15:00)"
                if ($scheduleTime -notmatch "^\d{1,2}:\d{2}$") {
                    Write-Host "Invalid time format. Please enter in HH:mm format."
                }
            }
        
            # Prompt for day of week if weekly
            if ($scheduleFrequency -eq "daily") {
                $trigger = New-ScheduledTaskTrigger -Daily -At $scheduleTime
            } elseif ($scheduleFrequency -eq "weekly") {
                $dayOfWeek = ""
                while ($dayOfWeek -notmatch "^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)$") {
                    $dayOfWeek = Read-Host "Enter the day of the week to run the backup (e.g., Monday)"
                    if ($dayOfWeek -notmatch "^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)$") {
                        Write-Host "Invalid day. Please enter a full day of the week like 'Monday'."
                    }
                }
                $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $dayOfWeek -At $scheduleTime
            }
        
            # Use the .bat file instead of the .ps1 directly
            $batPath = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) "run_wow_backup.bat"
            if (-not (Test-Path $batPath)) {
                throw "Batch file not found: $batPath"
            }
        
            $action = New-ScheduledTaskAction -Execute $batPath
        
            # Remove existing task if it exists
            if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
                Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            }
        
            # Register the task using the .bat
            Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Automated backup for WowUI" -User $env:UserName -RunLevel Highest
        
            # Update config with Scheduled = true
            $config = @{
                Parent      = $config.Parent
                Destination = $config.Destination
                Scheduled   = $true
            }            
            $config | ConvertTo-Json | Set-Content -Path $configPath
        
            Write-Output "Scheduled task '$taskName' has been created and will run $scheduleFrequency at $scheduleTime."
            Write-Host "`nCLick X in top right corner to close..."
            $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit
        }
        catch {
            Write-Error "❌ Failed to create scheduled task: $_"
            Write-Host "`nCLick X in top right corner to close..."
            $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit
        }
    }
}
