@echo off
echo =========================================
echo  Optimizing Windows 10 VM for MPLAB
echo =========================================
echo Running as Administrator? Check...
if not "%1"=="admin" (
    powershell -Command "Start-Process '%~f0' -ArgumentList 'admin' -Verb RunAs"
    exit
)

:: ========================
:: Registry tweaks
:: ========================
echo Applying registry tweaks...

:: Disable consumer features
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f

:: Background apps
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f

:: Telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

:: Cortana
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

:: Disable Bing Search in Start Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /t REG_DWORD /d 0 /f

:: Disable Windows tips
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f

:: Disable animations
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: Disable Game DVR
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f

:: Disable OneDrive auto-start
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f

echo Registry tweaks complete.
echo.

:: ========================
:: Service optimizations
:: ========================
echo Disabling unnecessary services...

:: Telemetry
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled

:: Consumer & Cloud
sc config OneSyncSvc start= disabled
sc config CDPUserSvc start= disabled
sc config PimIndexMaintenanceSvc start= disabled
sc config UserDataSvc start= disabled
sc config UnistoreSvc start= disabled

:: Xbox / Gaming
sc config XblGameSave start= disabled
sc config XboxNetApiSvc start= disabled
sc config XboxGipSvc start= disabled
sc config XblAuthManager start= disabled

:: Search & indexing
sc config WSearch start= disabled

:: Push notifications
sc config WpnService start= disabled
sc config WpnUserService start= disabled

:: Printer / Fax (optional)
sc config Spooler start= disabled
sc config Fax start= disabled

:: SmartCard / biometrics (optional)
sc config SCardSvr start= disabled
sc config ScDeviceEnum start= disabled
sc config WbioSrvc start= disabled

:: Maps / sensors
sc config MapsBroker start= disabled
sc config lfsvc start= disabled
sc config SensorService start= disabled

echo Services disabled.
echo.

:: ========================
:: Done
:: ========================
echo Optimization complete!
echo It is recommended to reboot your VM now.
pause
shutdown /r /t 10
