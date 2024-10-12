💾 How to Update and Schedule Your WoW Backup Script
✏️ Step 1: Download and Edit the Script
Download the Script
First, grab the wowBackup.ps1 script and save it to your local machine.

Edit the Script to Match Your Folders
You no longer need to manually update folder paths! The script will now prompt you to select your Interface and WTF folders and choose a backup destination. Here's how you can use the script:

Select Folders When Running the Script:

Upon execution, the script will prompt you to select the folder locations for your:
Interface folder
WTF folder
Backup destination folder
Save the changes if you made any modifications to the script, and you're ready to run it.

Run the Script Manually
Open PowerShell as Administrator:
Press Win + X and select Windows PowerShell (Admin).
Temporarily bypass the script execution policy to allow it to run:
powershell
Copy code
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Navigate to the folder where you saved the script using the cd command:
powershell
Copy code
cd C:\Path\To\Script
Run the backup script:
powershell
Copy code
.\wowBackup.ps1
The script will now guide you through selecting your folders and backup location.

⏰ Step 2: Schedule the Script to Run Automatically
Save the Script
Make sure the script is saved as wowBackup.ps1 on your system.

Open Task Scheduler
Press Win + S, type Task Scheduler, and open it.
Create a New Task
In the Actions pane, click Create Task.
Configure the Task
In the General tab:
Give your task a name (e.g., "WoW Backup Script").
Choose Run whether user is logged on or not.
In the Triggers tab:
Click New.
Set the schedule for your task (e.g., weekly or daily).
In the Actions tab:
Click New.
In Program/script, enter:
powershell
Copy code
powershell.exe
In the Add arguments (optional) field, enter:
powershell
Copy code
-File "C:\Path\To\wowBackup.ps1"
In the Conditions tab:
Uncheck Start the task only if the computer is on AC power if you want it to run on battery.
In the Settings tab:
Make sure Allow task to be run on demand is checked.
Save and Enable
Click OK.
If prompted, enter your Windows password to allow the task to run with elevated privileges.
💡 Tips & Tricks
Always test the script manually first to ensure it's working correctly before setting up the schedule.
You can modify the script to log the status of backups (or errors) to a log file for easy monitoring.
Adjust the schedule frequency depending on how often you update your WoW addons.
