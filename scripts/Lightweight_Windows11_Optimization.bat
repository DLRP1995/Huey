
:: Lightweight Windows 11 Optimization Script
:: Removes unnecessary programs, settings, and files for a slimmer OS experience.
@echo off

:: Run as Administrator
if not "%~1"=="admin" (powershell -Command "Start-Process '%~f0' -ArgumentList 'admin' -Verb RunAs" & exit /b)

:: Disable unnecessary services
echo Disabling unnecessary services...
powershell -Command "Get-Service | Where-Object { $_.Status -eq 'Running' -and $_.CanStop -eq $true -and ($_.DisplayName -notmatch '(Windows Update|Audio|Network)') } | Stop-Service"

:: Remove default Windows apps
echo Removing default Windows apps...
powershell -Command "Get-AppxPackage | Where-Object { $_.Name -notmatch '(Microsoft.Store|Xbox|Photos)' } | Remove-AppxPackage"

:: Clean temporary files
echo Cleaning temporary files...
del /q /s %TEMP%\*
rd /s /q %TEMP%\
echo Temp files cleaned.

:: Disable visual effects for performance
echo Disabling visual effects for performance...
powershell -Command "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2"

:: Remove unnecessary startup items
echo Removing unnecessary startup items...
powershell -Command "Get-CimInstance Win32_StartupCommand | Remove-CimInstance"

:: Optimize power plan
echo Setting high-performance power plan...
powercfg -SETACTIVE SCHEME_MIN

:: Disable telemetry and tracking
echo Disabling telemetry and tracking...
powershell -Command "Stop-Service diagtrack"
powershell -Command "Set-Service diagtrack -StartupType Disabled"

:: Summary
echo Optimization complete! Your system is now lighter and faster.
pause
exit
