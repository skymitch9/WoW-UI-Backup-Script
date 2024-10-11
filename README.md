# WOW Update

How to update the script with your locations
1. Download Script
2. right click edit in any editor (notepad, npp, powershell)
3. Update these variables in lines 2,3,and 4 by right click editting the script <br>
```interfaceFolder = "your WTF folder Location"``` <br>
```$wtfFolder = "your interface folder location"``` <br>
```$destinationFolder = "where you want to store your backups"``` <br>
4. run powershell as administrator and enter this line ```Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass``` <br>
5. enter command .\wowBackup.ps1 while cd'd into folder location

How to Schedule This Script:
1. Save the script as wowBackup.ps1.
2. Open Task Scheduler and create a new task.
3. In the General tab, name your task.
4. In the Triggers tab, click New, set the task to run weekly.
5. In the Actions tab, click New and browse to ```powershell.exe```.
6. In the Add arguments (optional) field, enter: ```-File "C:\Path\To\wowBackup.ps1"```
7. Click OK to save your task.
