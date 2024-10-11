# Variables for the folders to copy and zip
$interfaceFolder = "G:\BlizzardLibrary\World of Warcraft\_retail_\Interface"
$wtfFolder = "G:\BlizzardLibrary\World of Warcraft\_retail_\WTF"
$destinationFolder = "C:\Users\nbasl\OneDrive\Documents\wowUIBackups"

# Ensure the destination folder exists
if (!(Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder
}

# Get current date for the zip file names
$date = Get-Date -Format "yyyy-MM-dd"

# Define the zip file names
$interfaceZip = "$destinationFolder\Interface_Backup_$date.zip"
$wtfZip = "$destinationFolder\WTF_Backup_$date.zip"

# Function to zip a folder
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

# Copy and zip the folders
Copy-Item -Path $interfaceFolder -Destination "$destinationFolder\Interface" -Recurse
Copy-Item -Path $wtfFolder -Destination "$destinationFolder\WTF" -Recurse

# Zip the copied folders
Zip-Folder -source "$destinationFolder\Interface" -destination $interfaceZip
Zip-Folder -source "$destinationFolder\WTF" -destination $wtfZip

# Clean up copied folders after zipping (optional)
Remove-Item "$destinationFolder\Interface" -Recurse -Force
Remove-Item "$destinationFolder\WTF" -Recurse -Force
