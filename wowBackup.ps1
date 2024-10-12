# Function to prompt the user to select a folder
function Select-Folder {
    param (
        [string]$message
    )
    $folder = New-Object -ComObject Shell.Application | ForEach-Object { $_.BrowseForFolder(0, $message, 0).self.Path }
    return $folder
}

# Prompt the user to select the Interface and WTF folders
$interfaceFolder = Select-Folder -message "Select the folder where Interface is located"
$wtfFolder = Select-Folder -message "Select the folder where WTF is located"

# Prompt the user to select the backup destination folder
$destinationFolder = Select-Folder -message "Select the destination folder for the backup"

# Check if the user selected folders correctly
if (-not $interfaceFolder -or -not $wtfFolder -or -not $destinationFolder) {
    Write-Output "Folder selection was canceled. Exiting script."
    exit
}

# Get current date and time for the new folder name
$date = Get-Date -Format "yyyy-MM-dd"
$time = Get-Date -Format "HHmm"
$newFolderName = "wowUI_${date}_$time"
$newDestinationFolder = "$destinationFolder\$newFolderName"

# Ensure the destination folder exists
if (!(Test-Path $newDestinationFolder)) {
    New-Item -ItemType Directory -Path $newDestinationFolder
}

# Copy the folders into the new destination folder
Copy-Item -Path $interfaceFolder -Destination "$newDestinationFolder\Interface" -Recurse
Copy-Item -Path $wtfFolder -Destination "$newDestinationFolder\WTF" -Recurse

# Define the zip file name for both folders together
$zipFile = "$destinationFolder\wowUI_Backup_${date}_$time.zip"

# Function to zip the folder
function Zip-Folder {
    param (
        [string]$source,
        [string]$destination
    )
    
    if (Test-Path $source) {
        Compress-Archive -Path $source -DestinationPath $destination -Force
    } else {
        Write-Output "The path '$source' does not exist."
    }
}

# Zip the entire wowUI folder, including both Interface and WTF folders
Zip-Folder -source $newDestinationFolder -destination $zipFile

# Clean up copied folders after zipping (optional)
Remove-Item $newDestinationFolder -Recurse -Force

# Notify the user that the backup is complete
Write-Output "Backup completed successfully. Zip file saved to: $zipFile"

# Prompt user if they want to set up an automated schedule
$setupScheduler = Read-Host "Do you want to schedule this backup to run automatically? (yes/no)"
if ($setupScheduler -eq "yes") {
    # Define the task name and script path
    $taskName = "WowUI_Backup"
    $scriptPath = $MyInvocation.MyCommand.Definition # Automatically gets the path to this script

    # Prompt the user for schedule time (daily or weekly)
    $scheduleFrequency = Read-Host "How often do you want to run the backup? (daily/weekly)"
    $scheduleTime = Read-Host "Enter the time for the task to run (e.g., 15:00 for 3:00 PM)"

    # Create the scheduled task trigger
    if ($scheduleFrequency -eq "daily") {
        $trigger = New-ScheduledTaskTrigger -Daily -At $scheduleTime
    } elseif ($scheduleFrequency -eq "weekly") {
        $dayOfWeek = Read-Host "Enter the day of the week to run the backup (e.g., Monday)"
        $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $dayOfWeek -At $scheduleTime
    } else {
        Write-Output "Invalid schedule frequency. Exiting script."
        exit
    }

    # Create the action to run the script
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File `"$scriptPath`""

    # Register the scheduled task
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Automated backup for WowUI" -User $env:UserName -RunLevel Highest

    Write-Output "Scheduled task '$taskName' has been created and will run $scheduleFrequency at $scheduleTime."
}
