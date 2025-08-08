@echo off
:: Batch file to launch PowerShell script as admin

:: Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running as admin
) else (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%~dp0Setup.bat'"
    exit /b
)

:: Launch the PowerShell script
echo Starting development environment setup...
powershell -ExecutionPolicy Bypass -File "%~dp0java-dev-setup.ps1"

pause