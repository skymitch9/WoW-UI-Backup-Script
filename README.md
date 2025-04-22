💾 WoW Backup Script & Scheduler

📦 About This Script

    This backup tool creates timestamped .zip archives of your World of Warcraft Interface and WTF folders. 
    It runs interactively or on a schedule, with admin elevation handled automatically via a batch launcher.

🚀 Quick Start
## 📦 Download and Use the WoW Backup Script

1. Go to the [Releases](../../releases) section of this repository.
2. Download the latest `WoWBackup_<version>.zip` file.
3. Extract the contents to a folder of your choice.
4. Double-click `run_wow_backup.bat` to launch the backup script with administrator privileges.

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