@echo off
:: Launch the uninstall script with admin rights

set scriptPath=%~dp0scripts\uninstall_wow_backup.ps1

>nul 2>&1 "%SystemRoot%\system32\cacls.exe" "%SystemRoot%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

powershell -ExecutionPolicy Bypass -File "%scriptPath%"
