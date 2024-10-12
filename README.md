# 💾 How to Update and Schedule Your WoW Backup Script

## ✏️ Step 1: Download and Run the Script

### Download the Script from GitHub
1. Navigate to the GitHub repository where the `wowBackup.ps1` script is hosted.
2. Locate the `wowBackup.ps1` file in the repository.
3. To download the file:
   - Click on the file name `wowBackup.ps1`.
   - Click the **Raw** button to view the script in plain text.
   - Right-click on the page and select **Save As** to save the file to your local machine.
   - Save the file with the `.ps1` extension (e.g., `wowBackup.ps1`).

   Alternatively, you can:
   - Click the **Download ZIP** button (if available) in the repository to download all files.
   - Extract the ZIP and locate the `wowBackup.ps1` script.

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
```powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass```

<br> 

## ⏰ Step 2: Schedule the Script to Run Automatically

### Save the Script
Make sure the script is saved as `wowBackup.ps1` on your system.

### Open Task Scheduler
1. Press `Win + S`, type **Task Scheduler**, and open it.

### Create a New Task
1. In the **Actions** pane, click **Create Task**.

### Configure the Task

#### In the **General** tab:
1. Give your task a name (e.g., "WoW Backup Script").
2. Choose **Run whether user is logged on or not**.

#### In the **Triggers** tab:
1. Click **New**.
2. Set the schedule for your task (e.g., weekly or daily).

#### In the **Actions** tab:
1. Click **New**.
2. In **Program/script**, enter:
    ```powershell
    powershell.exe
    ```
3. In the **Add arguments (optional)** field, enter:
    ```powershell
    -File "C:\Path\To\wowBackup.ps1"
    ```

#### In the **Conditions** tab:
1. Uncheck **Start the task only if the computer is on AC power** if you want it to run on battery.

#### In the **Settings** tab:
1. Make sure **Allow task to be run on demand** is checked.

### Save and Enable
1. Click **OK**.
2. If prompted, enter your Windows password to allow the task to run with elevated privileges.
