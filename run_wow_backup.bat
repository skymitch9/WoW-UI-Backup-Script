@echo off
:: Batch file to launch wowBackup.ps1 with admin rights

:: Set the full path to your PowerShell script
set scriptPath=%~dp0wowBackup.ps1

:: Check if run from Task Scheduler (SESSIONNAME usually is "Console" or missing in Scheduled Tasks)
setlocal EnableDelayedExpansion
if not defined SESSIONNAME (
    goto skipElevationCheck
)

:: Check for admin privileges (only when run interactively)
>nul 2>&1 "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:skipElevationCheck
:: Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%scriptPath%"
