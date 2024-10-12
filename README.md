# 💾 How to Update and Schedule Your WoW Backup Script

## ✏️ Step 1: Download and Edit the Script

### Download the Script
First, grab the `wowBackup.ps1` script and save it to your local machine.

### Edit the Script to Match Your Folders
You no longer need to manually update folder paths! The script will now prompt you to select your `Interface` and `WTF` folders and choose a backup destination. Here's how you can use the script:

1. **Select Folders When Running the Script**:
   - Upon execution, the script will prompt you to select the folder locations for your:
     - **Interface folder**
     - **WTF folder**
     - **Backup destination folder**

2. **Save the changes** if you made any modifications to the script, and you're ready to run it.

### Run the Script Manually

#### Open PowerShell as Administrator:
- Press `Win + X` and select **Windows PowerShell (Admin)**.

#### Temporarily bypass the script execution policy to allow it to run:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
