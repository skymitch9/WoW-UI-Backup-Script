# WOW Update

How to Schedule This Script:
Save the script as wowBackup.ps1.
Open Task Scheduler and create a new task.
In the General tab, name your task.
In the Triggers tab, click New, set the task to run weekly.
In the Actions tab, click New and browse to powershell.exe.
In the Add arguments (optional) field, enter:
arduino
Copy code
-File "C:\Path\To\backupScript.ps1"
Click OK to save your task.
