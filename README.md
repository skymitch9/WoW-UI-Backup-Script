# WOW Update

How to Schedule This Script:
1. Save the script as wowBackup.ps1.
2. Open Task Scheduler and create a new task.
3. In the General tab, name your task.
4. In the Triggers tab, click New, set the task to run weekly.
5. In the Actions tab, click New and browse to ```powershell.exe```.
6. In the Add arguments (optional) field, enter: ```-File "C:\Path\To\wowBackup.ps1"```
7. Click OK to save your task.
