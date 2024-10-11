# 💾 How to Update and Schedule Your WoW Backup Script

### ✏️ Step 1: Download and Edit the Script

1. **Download the Script**  
   First, grab the `wowBackup.ps1` script and save it to your local machine.

2. **Edit the Script to Match Your Folders**  
   - Right-click the script file and select **Edit** (Notepad, Notepad++, PowerShell ISE, whichever works for you).
   - Update the following variables with your specific folder paths:
     ```powershell
     $interfaceFolder = "C:\Path\To\Your\Interface\Folder"
     $wtfFolder = "C:\Path\To\Your\WTF\Folder"
     $destinationFolder = "C:\Path\Where\You\Want\To\Store\Backups"
     ```
   - Save the changes.

3. **Run the Script Manually**
   - Open **PowerShell as Administrator**:
     - Press `Win + X` and select **Windows PowerShell (Admin)**.
   - Temporarily bypass the script execution policy to allow it to run:
     ```powershell
     Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
     ```
   - Navigate to the folder where you saved the script using the `cd` command:
     ```powershell
     cd C:\Path\To\Script
     ```
   - Run the backup script:
     ```powershell
     .\wowBackup.ps1
     ```

---

### ⏰ Step 2: Schedule the Script to Run Automatically

1. **Save the Script**  
   Make sure the script is saved as `wowBackup.ps1` on your system.

2. **Open Task Scheduler**  
   - Press `Win + S`, type **Task Scheduler**, and open it.

3. **Create a New Task**  
   - In the **Actions** pane, click **Create Task**.

4. **Configure the Task**
   - In the **General** tab:
     - Give your task a name (e.g., "WoW Backup Script").
     - Choose **Run whether user is logged on or not**.
   - In the **Triggers** tab:
     - Click **New**.
     - Set the schedule for your task (e.g., weekly or daily).
   - In the **Actions** tab:
     - Click **New**.
     - In **Program/script**, enter:
       ```powershell
       powershell.exe
       ```
     - In the **Add arguments (optional)** field, enter:
       ```powershell
       -File "C:\Path\To\wowBackup.ps1"
       ```
   - In the **Conditions** tab:
     - Uncheck **Start the task only if the computer is on AC power** if you want it to run on battery.
   - In the **Settings** tab:
     - Make sure **Allow task to be run on demand** is checked.

5. **Save and Enable**  
   - Click **OK**.
   - If prompted, enter your Windows password to allow the task to run with elevated privileges.

---

### 💡 Tips & Tricks
- Always test the script manually first to ensure it's working correctly before setting up the schedule.
- You can modify the script to log the status of backups (or errors) to a log file for easy monitoring.
- Adjust the schedule frequency depending on how often you update your WoW addons.
