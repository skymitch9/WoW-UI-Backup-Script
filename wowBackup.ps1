# Variables for the folders to copy and zip
$sourceFolder1 = "C:\Users\nbasl\OneDrive\Documents\test1"
$sourceFolder2 = "C:\Users\nbasl\OneDrive\Documents\test2"
$destinationFolder = "C:\Users\nbasl\OneDrive\Documents\scripts\backup"

# Get current date for the zip file names
$date = Get-Date -Format "yyyy-MM-dd"

# Define the zip file names
$zipFile1 = "$destinationFolder\Interface_Backup_$date.zip"
$zipFile2 = "$destinationFolder\WTF_Backup_$date.zip"

# Function to zip a folder
function Zip-Folder {
    param (
        [string]$source,
        [string]$destination
    )
    
    if (Test-Path $destination) {
        Remove-Item $destination
    }
    
    Compress-Archive -Path $source -DestinationPath $destination
}

# Copy and zip the folders
Copy-Item -Path $sourceFolder1 -Destination $destinationFolder -Recurse
Copy-Item -Path $sourceFolder2 -Destination $destinationFolder -Recurse

# Zip the copied folders
Zip-Folder -source "$destinationFolder\test1" -destination $zipFile1
Zip-Folder -source "$destinationFolder\test2" -destination $zipFile2

# Clean up copied folders after zipping (optional)
Remove-Item "$destinationFolder\test1" -Recurse
Remove-Item "$destinationFolder\test2" -Recurse
