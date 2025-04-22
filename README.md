💾 WoW Backup Script & Scheduler

📦 How to Use This Script

    This backup tool creates timestamped .zip archives of your World of Warcraft Interface and WTF folders. 
    It runs interactively or on a schedule, with admin elevation handled automatically via a batch launcher.

🧾 Files Included
File	Description
wowBackup.ps1	The main PowerShell script. Prompts folder selection, creates a backup, and offers to schedule itself.
run_wow_backup.bat	Launches wowBackup.ps1 with administrator rights — required for scheduling.
wowUI_config.json	Generated on first run. Stores your chosen folders and scheduling status.
🚀 Quick Start (GitHub ZIP Release)
✅ Download from GitHub Releases:

    Go to the Releases section of the repository.

    Download the latest .zip package (e.g., WoWBackup_v1.0.zip).

    Extract the ZIP into a folder such as:

    C:\WoWBackup

✅ Run It:

    Double-click run_wow_backup.bat — it will launch wowBackup.ps1 with admin rights.

    Follow the prompts to:

        Select folders

        Choose a backup destination

        Optionally schedule automatic backups

⏰ Scheduling Behavior (Automated)

    If you opt in, the script will:

        Ask for frequency (daily/weekly)

        Ask for time of day (24-hour format)

        Register a Task Scheduler task named WowUI_Backup

🔁 Resetting or Reconfiguring

To reconfigure:

    Delete the file: wowUI_config.json

    Re-run run_wow_backup.bat

This will let you choose folders again and reconfigure the scheduler.

💡 Pro Tips

    Backups are saved as zip files in your chosen destination folder

    Backups are timestamped like: wowUI_Backup_2025-04-16_2205.zip

    Old backups are never overwritten (you can prune them manually if needed)

🧹 Uninstalling / Removing the Task

To remove the scheduled task manually:

Run in Powershell as admin: Unregister-ScheduledTask -TaskName "WowUI_Backup" -Confirm:$false

To reset everything, delete:

    wowUI_config.json

    The scheduled task (WowUI_Backup)

    Any backup .zip files