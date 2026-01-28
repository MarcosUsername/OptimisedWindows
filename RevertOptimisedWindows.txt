@echo off
echo =========================================
echo  Reverting Windows Optimizations
echo =========================================
echo Running as Administrator? Check...
if not "%1"=="admin" (
    powershell -Command "Start-Process '%~f0' -ArgumentList 'admin' -Verb RunAs"
    exit
)

:: ========================
:: Registry reverts
:: ========================
echo Reverting registry changes...

:: Consumer features
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /f

:: Background apps
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /f

:: Telemetry
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f

:: Cortana / Search
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v CortanaConsent /f

:: Windows tips
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /f

:: Animations
reg delete "HKCU\Control Panel\Desktop" /v UserPreferencesMask /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /f

:: Game DVR
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f

:: OneDrive
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /f

echo Registry reverted.
echo.

:: ========================
:: Service reverts
:: ========================
echo Restoring services...

:: Telemetry
sc config DiagTrack start= auto
sc config dmwappushservice start= auto

:: Sync / Cloud
sc config OneSyncSvc start= demand
sc config CDPUserSvc start= demand
sc config PimIndexMaintenanceSvc start= demand
sc config UserDataSvc start= demand
sc config UnistoreSvc start= demand

:: Xbox / Gaming
sc config XblGameSave start= demand
sc config XboxNetApiSvc start= demand
sc config XboxGipSvc start= auto
sc config XblAuthManager start= demand

:: Search
sc config WSearch start= auto

:: Push notifications
sc config WpnService start= auto
sc config WpnUserService start= demand

:: Printer / Fax
sc config Spooler start= auto
sc config Fax start= demand

:: SmartCard / biometrics
sc config SCardSvr start= demand
sc config ScDeviceEnum start= demand
sc config WbioSrvc start= demand

:: Maps / sensors
sc config MapsBroker start= demand
sc config lfsvc start= demand
sc config SensorService start= demand

echo Services restored.
echo.

:: ========================
:: Done
:: ========================
echo Revert complete!
echo It is recommended to reboot now.
pause
shutdown /r /t 10
