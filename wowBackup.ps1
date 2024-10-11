# Variables for the folders to copy and zip
$interfaceFolder = "G:\BlizzardLibrary\World of Warcraft\_retail_\Interface"
$wtfFolder = "G:\BlizzardLibrary\World of Warcraft\_retail_\WTF"

# Variables for the folders to copy and zip
#$interfaceFolder = "C:\Users\nbasl\OneDrive\Documents\Interface"
#$wtfFolder = "C:\Users\nbasl\OneDrive\Documents\WTF"
$destinationFolder = "C:\Users\nbasl\OneDrive\Documents\wowUIBackups"

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
