@echo off
title DISM Manager
:tippytop
setlocal EnableDelayedExpansion



color 07
:: Location :c is faster but does not support special characters
:: Location :c2 is slower but supports anything


SETLOCAL EnableDelayedExpansion
if not "%1"=="am_admin" (call :c 0e "Loading as admin . . ." & cd>C:\users\Public\CDT.txt & powershell start -verb runas '%0' am_admin & exit /b)
:--------------------------------------    
set /p cdd=<C:\users\Public\CDT.txt
echo %cdd% | find "%SystemDrive%" >nul
if %errorlevel%==1 (
	call :c c0 "WARNING" /n
	call :c 0c " Your Current Directory Should be on your %systemdrive% drive."
	call :c 0f "Close and move or Press X to continue. " /n
	CALL :C 08 "(Not Recommended)"
	choice /c x /n
)
cd "%cdd%"
if not exist "C:\WinPE_amd64" goto noadk
if not exist "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\" goto noah


if exist CreatingISO goto okiso
if exist CreatingISO2 goto okiso2
DISM >nul
if %errorlevel%==9009 echo DISM NOT INSTALLED! Please install Microsoft ADK. & pause & exit
if %errorlevel%==740 echo Administration Failed! Please try again, or call in admin cmd.exe & pause & exit
if not %errorlevel%==0 echo ERROR %errorlevel% ! Continue?  & choice & if %errorlevel%==2 exit
if not exist lc.exe goto nolc
:backlc

::main Menu
:top
if not exist mount (
	if exist C:\WinPE_amd64\mount\Windows call :c 0c "An Error may have occured." /n /u
	if exist C:\WinPE_amd64\mount\Windows call :c 0c "Locally the Drive is set to not mounted, However some mounted files still exist on the PC."
	if exist C:\WinPE_amd64\mount\Windows call :c 0c "If you have moved directories with this program since mount it may have caused this."
	if exist C:\WinPE_amd64\mount\Windows call :c 08 "Opening the mount folder should tell you if this is true."
	if exist C:\WinPE_amd64\mount\Windows pause
)
cls
title DISM ITCMD Boot Manager 2.3.17 by Lucas Elliott            Press 9 For Settings            %cd%
echo IT COMMMAND BOOT MANAGER FOR WINPE VERSION 2.3 by Lucas Elliott      [(c) 2018 all rights reserved]
echo =======================================================================================================
call :c 0f "Mount Status: " /n
if not exist mount call :c 0c "Not Mounted" /n /u
if not exist mount if not exist lst call :c 0b "   No Previous Mount Data Found" & goto nolst
if not exist mount call :c 0f "   Last Mounted: " /n
if not exist mount set /p lst=<lst
if not exist mount call :c 0b "%lst%"
:nolst
if exist mount call :callm
echo ======================================================================================================
call :c 0f "Please Select an option:"
if not exist mount call :c 0f "1] Mount from C:\"
if exist mount call :c 07 "1] Mount from C:\"
if not exist mount call :c 0f "2] Mount from Drive"
if exist mount call :c 07 "2] Mount from Drive"
if exist mount call :c 0f "3] Unmount"
if not exist mount call :c 07 "3] Unmount"
if exist mount call :c 07 "4] Install from C to drive"
if not exist mount call :c 0f "4] Install from C to drive"
call :c 0f "5] Open Mount Folder"
call :c 0f "6] Backup Manager"
if exist mount call :c 07 "7] Install from C to iso"
if not exist mount call :c 0f "7] Install from C to iso"
if exist mount call :c 07 "8] Install from USB to iso"
if not exist mount call :c 0f "8] Install from USB to iso"
call :c 0f "9] Settings"
set yes=no1
:cho
if %yes%==yes call :c 08 "Invalid Option"
set yes=yes
choice /c "123456789" /n >nul
title DISM ITCMD Boot Manager 2.0.1 by Lucas Elliott
if %errorlevel%==9 goto setting
if %errorlevel%==5 goto 5
if %errorlevel%==6 goto 6
if exist mount if not %errorlevel%==3 goto cho
if not exist mount if %errorlevel%==3 goto cho
cls
goto %errorlevel%


:nono
cls
call :c 0c "Drive was not valid."
pause
goto top

:exists2
echo A WinPE ISO Image already Exists. Overwrite?
choice
if %errorlevel%==2 goto top
del /f /q "C:\user\%username%\Desktop\WinPE_USB_amd64.iso"
goto overwrit2
:8
cls
echo Please Enter the Drive name (example: E:)
set /p drve=">"
if not exist %drve%\boot\*.* goto nono
cls
call :c 0a "This will create an iso on your Desktop folder called WinPE_USB_amd64.iso from %drve%:\ Okay?"
choice
if %errorlevel%==2 goto top
cls
if exist "C:\user\%username%\Desktop\WinPE_USB_amd64.iso" goto exists2
:overwrit2
cls
call :c 0c "WARNING:" /n
call :c 0f " Due to how an ADK tool works, this program will exit on completion. It will Continue on Startup"
pause
call :c 0a "Starting create ISO . . ."
echo. >CreatingISO2
pushd C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg
"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\MakeWinPEMedia.cmd" /ISO %drve% "C:\user\%username%\Desktop\WinPE_USB_amd64.iso"
timeout /t 2 >nul
popd
del /f /q CreatingISO
call :FAIL


:okiso2
call :c 0f "Testing ISO Status..."
del /f /q CreatingISO
if not exist "C:\user\%username%\Desktop\WinPE_USB_amd64.iso" goto failiso
call :c 0a "Completed. Test Shows Positive Results" 
pause
goto top

:failiso
cls
call :c 0c "It seems the iso creation failed." /u
pause
goto top




:exists
echo A WinPE ISO Image already Exists. Overwrite?
choice
if %errorlevel%==2 goto top
del /f /q C:\WinPE_amd64\WinPE_amd64.iso
goto overwrit
:7
cls
call :c 0a "This will create an iso in your mount folder called WinPE_amd64.iso Okay?"
choice
if %errorlevel%==2 goto top
cls
if exist C:\WinPE_amd64\WinPE_amd64.iso goto exists
:overwrit
cls
call :c 0c "WARNING:" /n
call :c 0f " Due to how an ADK tool works, this program will exit on completion. It will Continue on Startup"
pause
call :c 0a "Starting create ISO . . ."
echo. >CreatingISO
pushd C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg
"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\MakeWinPEMedia.cmd" /ISO C:\WinPE_amd64 C:\WinPE_amd64\WinPE_amd64.iso
timout /t 2 >nul
popd
del /f /q CreatingISO
call :FAIL


:okiso
call :c 0f "Testing ISO Status..."
del /f /q CreatingISO
if not exist C:\WinPE_amd64\WinPE_amd64.iso goto failiso
call :c 0a "Completed. Test Shows Positive Results" 
pause
goto top

:theendoftheworldasweknowit
cls
echo ITs the end of the world as we know it....
echo ITs the end of the world.... doo doo dooo...
pause
goto top

:setting
cls
echo SETTINGS               Version 1.0
echo ======================================
call :c 0f "1] Toggle Sounds On Finish" /n
if exist sound call :c 0c "  [OFF]"
if not exist sound call :c 0a "  [ON]"
call :c 0f "2] Uninstall ADK"
call :c 0f "3] Repair ADK"
call :c 0f "4] Remove Status Files"
call :c 0f "5] Launch Cleanup"
call :c 0f "6] Back to Menu"
choice /c "123456" /n
if %errorlevel%==2 goto uninadk
if %errorlevel%==3 goto repadk
if %errorlevel%==6 goto top
if %errorlevel%==4 goto delf
if %errorlevel%==5 goto cleanupses
if exist sound del /f /q sound & goto setting
if not exist sound echo.> sound
goto setting

:cleanupses
cls
call :c 0a "Starting Cleanup . . ."
dism /cleanup-wim
call :c 0a "Completed."
pause
goto top

:delf
cls
echo Continuing will remove current status files, and will
echo show the status as not mounted.
echo This is usefull if an error occured and thestatus really is unmounted
echo If you currently have a drive or something mounted this may cause problems.
echo THIS WILL NOT UNMOUNT OR MOUNT ANYTHING
call :c 08 "Are you sure you want to do this?"
choiceif %errorlevel%==2 goto top
set radn=%random%
cls
call :c 0c "Enter the Following Verification Code:"
call :c 0f " %radn%"
set /p cho=">"
if not "%cho%"=="%radn%" goto top
echo DELETING . . .
del /f /q old.txt
del /f /q new.txt
del /f /q mount2
timeout /t 2 >nul
goto top


:5
start "" "C:\WinPE_amd64"
goto top

:callm
::info for menu
set /p dat=<date
set /p tim=<time
set /p typ=<type
call :c 0a "Mounted" /n /u
call :c 0f "  Mounted: " /n
call :c 0b " %dat% " /n
call :c 0b "%tim%  " /n
call :c 0f "Directory: " /n
call :c 0b "C:\WinPE_amd64\mount  " /n
call :c 0f "From: " /n
call :c 0b "%typ%"
exit /b

:1
call :c 0a "Preparing to Mount Image . . ."
Dism /Mount-Image /ImageFile:"C:\WinPE_amd64\media\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
if not %errorlevel%==0 call :Fail
echo %date% >date
echo %time% >time
echo Local>type
dir /b /s C:\WinPE_amd64\mount >mount
echo %date% at %time% from Local Disk >lst
if not exist sound echo  
call :c 0a "Mounted."
if exist backups goto backupnow
pause
goto top



:3
call :c 0a "Loading Preview of Image to Unmount. Please Wait . . ."
dir /b /s C:\WinPE_amd64\mount >mount2
lc mount mount2
cls
if not exist backups call :c 0b "Changes Made to Mounted Drive"
if exist backups call :c 0b "Changes Made to Mounted Drive Since Backup"
echo ===================================================
call :c 0a "Added Files and Folders:"
type new.txt
echo.
call :c 0c "Removed Files and Folders:"
type old.txt
echo.
echo ===================================================
echo Are You Sure You want to continue with Unmount?
choice
if %errorlevel%==2 goto top
cls
call :c 0a "Preparing to Unmount Image . . ."
call :c 08 "Press C to Cancel Now . . ."
choice /c "QC" /n /d "Q" /t "4" >nul
if not %errorlevel%==1 goto cancel
del /f /q old.txt
del /f /q new.txt
del /f /q mount2
echo.
call :c 0a "Begining Unmount . . ."
Dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /commit
if not exist sound echo  
if not "%errorlevel%"=="0" call :Fail
del /f /q mount
del /f /q type
del /f /q time
del /f /q date
if exist mount2 del /f /q mount2
call :c 0a "Completed."
pause
goto top

:cancel
cls
call :colorech 0a "Cancled. Cleaning Up . . ."
del /f /q old.txt
del /f /q new.txt
del /f /q mount2
timeout /t 2 >nul
goto top



:2
call :c 0f "	      _____________________"
call :c 0f "	 ____[                     ]"
call :c 0f "	[  o [  Insert Flash Drive ]"
call :c 0f "	[__o_[     To Mount Now    ]"
call :c 0f "	     [_____________________]"
pause
set d=not
if exist D:\ vol D:>testD
if not exist D:\ echo not >testD
if exist E:\ vol E:>testE
if not exist E:\ echo not >testE
if exist F:\ vol F:>TestF
if not exist F:\ echo not >testF
if exist G:\ vol G:>TestG
if not exist G:\ echo not >testG
find "is WINPE" "TestD" >nul
if %errorlevel%==0 set d=D
find "is WINPE" "TestE" >nul
if %errorlevel%==0 set d=E
find "is WINPE" "TestF" >nul
if %errorlevel%==0 set d=F
find "is WINPE" "TestG" >nul
if %errorlevel%==0 set d=G
if "%d%"=="not" goto nok
echo %d%:\ is a Windows PE Drive. Use this drive?
choice
if %errorlevel%==2 goto nok
goto nxtd
:nok
echo Enter Drive Letter to Mount (Example: E)
set /p d=">"
echo %d%:\ will be the drive to boot from. correct?
choice
:nxtd
del /f /q testD
del /f /q testE
del /f /q testF
del /f /q testG
if %errorlevel%==2 goto top
if not exist %d%:\sources\boot.wim echo INCORRECT BOOT & goto 2
Dism /Mount-Image /ImageFile:"%D%:\sources\boot.wim" /index:1 /MountDir:"C:\WinPE_amd64\mount"
if not %errorlevel%==0 call :Fail
echo %date% >date
echo %time% >time
echo Drive %d%>type
dir /b /s C:\WinPE_amd64\mount >mount
if not exist sound echo  
call :c 0a "Mounted."
echo %date% at %time% from Drive %d% >lst
if exist backups goto backupnow
pause
goto top

:4
call :c 0f "	      _____________________"
call :c 0f "	 ____[                     ]"
call :c 0f "	[  o [  Insert Flash Drive ]"
call :c 0f "	[__o_[  To Install To Now  ]"
call :c 0f "	     [_____________________]"

echo Enter Drive Letter to Install Local WinPE to (Example: E)
set /p d=">"
"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\MakeWinPEMedia.cmd" /UFD C:\WinPE_amd64 %d%:
if not %errorlevel%==0 call :Fail
if not exist sound echo 
call :c 0a "Completed." 
pause
goto top


:backupnow
if not exist C:\Backup_WinPE_amd64_mount call :c 0c "WARNING: " /n & call :c 0f "This is the First Backup and May Take A While."
call :backup1 C:\WinPE_amd64\mount C:\Backup_WinPE_amd64_mount .metadata
dir /b /s C:\Win_PE_amd64\mount> lastbkpdir
call :c 0a "Completed."
if not exist sound echo  
pause
goto top

:6
cls
echo IT COMMMAND BOOT MANAGER FOR WINPE VERSION 2.1 by Lucas Elliott      [(c) 2018 all rights reserved]
echo =======================================================================================================
call :c 0f "BACKUP MANAGER VERSION 1.7" /n
if exist lastbkp set /p lstb=<lastbkp
if not exist lastbkp set lstb=NO BACKUP HISTORY FOUND
call :c 0f "   Last Backup:" /n
call :c 0b "  %lstb%"
if exist mount call :c 0f "1] Create New Backup"
if not exist mount echo 1] Create New Backup
if exist mount call :c 0f "2] Restore From Backup"
if not exist mount echo 2] Restore From Backup
call :c 0f "3] Toggle Automatic Backup" /n
if exist backups call :c 0a " [ON]"
if not exist backups call :c 0c " [OFF]"
call :c 0f "4] Back to Main Menu"
:chobb
choice /c "1234" /n >nul
if %errorlevel%==4 goto top
if %errorlevel%==3 goto changebackup
if not exist mount call :c 08 "Invalid Option" & goto chobb
if %errorlevel%==1 goto nwb
if %errorlevel%==2 goto rest
goto 6

:rest
if not exist C:\Backup_WinPE_amd64_mount call :c 0c "No Backup Exists to Restore From" & pause & goto 6
cls
call :c 0a "Loading Preview of Changes Made Since Last Backup . . ."
dir /b /s C:\WinPE_amd64\mount >newimage
lc lastbkpdir newimage
cls
call :c 0b "Changes Made to Mounted Drive Since Backup"
echo ===================================================================
call :c 0a "Added Files and Folders:"
type new.txt
echo.
call :c 0c "Removed Files and Folders:"
type old.txt
echo.
echo ===================================================================
echo NOTE: This will also revert changes made inside files!
set /p lstb=<lastbkp
del /f /q old.txt
del /f /q new.txt
del /f /q newimage
call :c 0f "Are You Sure You want to Revert the changes you've made since" %lstb%?
choice
if %errorlevel%==2 goto 6
cls
call :c 0a "Reverting Changes. This Will Take a While . . ."
xcopy "C:\Backup_WinPE_amd64_mount" "C:\WinPE_amd64\mount" /Y /E /C /H /R /K /O /Q
call :c 0a "Completed." /n
if not exist sound echo  
call :c 08 "  If any Error Messages are on Screen, take note of them."
pause
goto 6


:nwb
cls
if not exist C:\Backup_WinPE_amd64_mount call :c 0c "WARNING: " /n & call :c 0f "This is the First Backup and May Take A While."
call :backup1 C:\WinPE_amd64\mount C:\Backup_WinPE_amd64_mount .metadata
dir /b /s "C:\WinPE_amd64\mount" > lastbkpdir
if not exist sound echo  
call :c 0a "Completed."
echo %date%  %time% >lastbkp
pause
goto 6

:changebackup
if not exist backups echo Enabled> backups & goto 6
if exist backups del /f /q backups
goto 6





:fail
dism /get-mountedwiminfo >C:\users\Public\DismFailed.log
echo FATAL ERROR! End now? (No to Cleanup)
choice 
if %errorlevel%==1 goto top
echo Cleanup?
choice
if %errorlevel%==2 exit /b
dism /cleanup-wim
pause
if exist "C:\WinPE_amd64\mount\Windows" goto top
if exist "C:\WinPE_amd64\mount\Program Files" goto top
if exist "C:\WinPE_amd64\mount\Users" goto top
exit /b


:backup1
call :c 0a "Beginning Backup . . ."
REM get start time
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

REM set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
set "logtimestamp=%YYYY%.%MM%.%DD% %HH%:%Min%:%Sec%"

REM actual copy
set source=%1
set destination=%2

REM create the exclusion list
set exclusion=%3
set exclusion=%exclusion:"=%
(for %%i in (%exclusion%) do echo %%i) > exclusion.txt

REM set the file name for the logging data
set log=log-%fullstamp%.txt

REM start the backup process
echo // started backup at %logtimestamp% > %log%
echo // from %~f1 to %~f2\ >> %log%

echo ---- >> %log%
xcopy %source% %destination% /S /E /C /O /D /H /R /Y /V /I /EXCLUDE:exclusion.txt >> %log%
echo ---- >> %log%
del /f /q exclusion.txt

REM get finish time
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "logtimestamp=%YYYY%.%MM%.%DD% %HH%:%Min%:%Sec%"

echo // finished backup at %logtimestamp% >> %log%

REM move the logging
if not exist "C:\.amdbackup_log" mkdir C:\.amdbackup_log
move %log% C:\.amdbackup_log >nul
exit /b

:noah
cls
call :c 0a "Windows Assesment and Deployment Kit is not installed. It is required  to use DISM."
call :c 0a "Would You like to Download and Install it now? You can Uninstall it in settings."
choice
if %errorlevel%==2 exit
cls
call :c 0a "Would You like to Install the minimum requirements?"
choice
if %errorlevel%==2 goto noah2
call :c 0a "Great! Downloading the Installation . . ."
timeout /t 2 >nul
bitsadmin /transfer myDownloadJob /download /priority High  http://download.microsoft.com/download/6/8/9/689E62E5-C50F-407B-9C3C-B7F00F8C93C0/adk/adksetup.exe "%cd%\adkSetup.exe"
if not %errorlevel%==0 goto errnoah
call :c 0a "Download Completed. Launching. Install may take a while . . ."
adksetup /features OptionId.DeploymentTools OptionId.WindowsPreinstallationEnvironment
call :c 0a "ADK setup is launched. Please restart this program when installation is complete."
pause
exit


:uninadk
cls
call :c 0a "Are you sure you want to Uninstall the ADK?"
call :c 0c "This Program Will No Longer Work."
choice
if %errorlevel%==2 goto setting
cls
if exist adksetup.exe goto temp13
call :c 0a "Alright. Downloading Uninstall File. . ."
bitsadmin /transfer myDownloadJob /download /priority High  http://download.microsoft.com/download/6/8/9/689E62E5-C50F-407B-9C3C-B7F00F8C93C0/adk/adksetup.exe "%cd%\adkSetup.exe"
:temp13
call :c 0a "Launching the Uninstall File . . ."
adksetup /Uninstall
call :c 0a "ADK Uninstall is launched. We are sorry to see you go!"
call :c 08 "Contact Lucas@ITCommand.tech for more help!"
pause
exit


:repadk
cls
call :c 0a "Are you sure you want to repair the ADK Installation?"
choice
if %errorlevel%==2 goto setting
cls
if exist adksetup.exe goto temp13
call :c 0a "Great! Downloading Repair File . . ."
bitsadmin /transfer myDownloadJob /download /priority High  http://download.microsoft.com/download/6/8/9/689E62E5-C50F-407B-9C3C-B7F00F8C93C0/adk/adksetup.exe "%cd%\adkSetup.exe"
:temp13
call :c 0a "Launching the Repair File . . ."
adksetup /repair
call :c 0a "ADK repair is launched. Or Finished Installing. Please restart this program when installation is complete."
pause
exit


:noah2
call :c 0a "Great! Downloading the Installation..."
bitsadmin /transfer myDownloadJob /download /priority High  http://download.microsoft.com/download/6/8/9/689E62E5-C50F-407B-9C3C-B7F00F8C93C0/adk/adksetup.exe "%cd%\adkSetup.exe"
if not %errorlevel%==0 goto errnoah
call :c 0a "Download Completed. Launching..."
call :c 0f "You Must Install the Deployment Tools and the Preinstallation Enviornment, anything else is up to you!"
adksetup
call :c 0a "ADK setup is launched. Please relaunch when installation is complete."
pause
exit



:noadk
if not exist "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment" goto noah
cls
call :c 0a "It looks like you already have Windows ADK Installed. But this Program Requires an amd64 folder."
call :c 0a "Would you like to set up the amd64 WinPE Folder now?"
choice
if %errorlevel%==2 exit /b
::temp12
cls
call :c 0a "Setting Up Mount Folder."
set error=no
call :copype amd64 C:\WinPE_amd64 >log.temp
if %errorlevel%==1 call :c 0c "Error. Please Report to Lucas@ITCommand.tech" & type log.temp & call :c 0c "Error. Please Report to Lucas@ITCommand.tech" & set error=yes
if %error%==yes echo NOT PART OF LOG: THIS FILE WILL BE DELETED WHEN YOU CLOSE THE WINDOW! >>log.temp
pause
if %error%==yes notepad log.temp
del /f /q log.temp
if %error%==no goto ok
call :c 0a "Fail Deleted. Sorry You experienced an Error!"
call :c 0a "Check for updates at www.ITCommand.tech"
call :c 0a "And Email Lucas@ITCommand.tech so we can make it right!"
echo Press any key to Exit.
pause>nul
exit


:ok
cls
call :c 0a "Completed."
echo Press any key to restart . . .
pause>nul
goto tippytop

:copype
setlocal

set TEMPL=media
set FWFILES=fwfiles

rem
rem Input validation
rem
if /i "%1"=="/?" goto usage
if /i "%1"=="" goto usage
if /i "%~2"=="" goto usage
if /i not "%3"=="" goto usage

rem
rem Set environment variables for use in the script
rem
set WINPE_ARCH=%1
set SOURCE=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\%WINPE_ARCH%
set FWFILESROOT=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\%WINPE_ARCH%\Oscdimg
set DEST=%~2
set WIMSOURCEPATH=%SOURCE%\en-us\winpe.wim

rem
rem Validate input architecture
rem
rem If the source directory as per input architecture does not exist,
rem it means the architecture is not present
rem
if not exist "%SOURCE%" (
  echo ERROR: The following processor architecture was not found: %WINPE_ARCH%.
  exit /b 1
)

rem
rem Validate the boot app directory location
rem
rem If the input architecture is validated, this directory must exist
rem This check is only to be extra careful
rem
if not exist "%FWFILESROOT%" (
  echo ERROR: The following path for firmware files was not found: "%FWFILESROOT%".
  exit /b 1
)

rem
rem Make sure the appropriate winpe.wim is present
rem
if not exist "%WIMSOURCEPATH%" (
  echo ERROR: WinPE WIM file does not exist: "%WIMSOURCEPATH%".
  exit /b 1
)

rem
rem Make sure the destination directory does not exist
rem
if exist "%DEST%" (
  echo ERROR: Destination directory exists: %2.
  exit /b 1
)

mkdir "%DEST%"
if errorlevel 1 (
  echo ERROR: Unable to create destination: %2.
  exit /b 1
)

echo.
echo ===================================================
echo Creating Windows PE customization working directory
echo.
echo     %DEST%
echo ===================================================
echo.

mkdir "%DEST%\%TEMPL%"
if errorlevel 1 goto :FAIL
mkdir "%DEST%\mount"
if errorlevel 1 goto :FAIL
mkdir "%DEST%\%FWFILES%"
if errorlevel 1 goto :FAIL

rem
rem Copy the boot files and WinPE WIM to the destination location
rem
xcopy /cherky "%SOURCE%\Media" "%DEST%\%TEMPL%\"
if errorlevel 1 goto :FAIL
mkdir "%DEST%\%TEMPL%\sources"
if errorlevel 1 goto :FAIL
copy "%WIMSOURCEPATH%" "%DEST%\%TEMPL%\sources\boot.wim"
if errorlevel 1 goto :FAIL

rem
rem Copy the boot apps to enable ISO boot
rem
rem  UEFI boot uses efisys.bin
rem  BIOS boot uses etfsboot.com
rem
copy "%FWFILESROOT%\efisys.bin" "%DEST%\%FWFILES%"
if errorlevel 1 goto :FAIL
if exist "%FWFILESROOT%\etfsboot.com" (
  copy "%FWFILESROOT%\etfsboot.com" "%DEST%\%FWFILES%"
  if errorlevel 1 goto :FAIL
)

endlocal
echo.
echo Success
echo.

cd /d "%~2"

goto :EOF

:usage
echo Creates working directories for WinPE image customization and media creation.
echo.
echo copype { amd64 ^| x86 ^| arm } ^<workingDirectory^>
echo.
echo  amd64             Copies amd64 boot files and WIM to ^<workingDirectory^>\media.
echo  x86               Copies x86 boot files and WIM to ^<workingDirectory^>\media.
echo  arm               Copies arm boot files and WIM to ^<workingDirectory^>\media.
echo                    Note: ARM content may not be present in this ADK.
echo  workingDirectory  Creates the working directory at the specified location.
echo.
echo Example: copype amd64 C:\WinPE_amd64
goto :EOF

:FAIL
echo ERROR: Failed to create working directory.
set EROP=YEs
exit /b 1
Rem CopyPE created by Microsoft and Edited by Lucas Elliott and wjsorensen on technet
::------------------------ END --------------------------



:nolc
echo -----BEGIN CERTIFICATE----- >LC1.exe
(echo TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAgAAAAA4fug4AtAnNIbgBTM0hVGhpcyBwcm9ncmFtIGNhbm5v
echo dCBiZSBydW4gaW4gRE9TIG1vZGUuDQ0KJAAAAAAAAABQRQAATAEDAE5+KlsAAAAA
echo AAAAAOAAIgALATAAAAwAAAAIAAAAAAAAMioAAAAgAAAAQAAAAABAAAAgAAAAAgAA
echo BAAAAAAAAAAEAAAAAAAAAACAAAAAAgAAAAAAAAMAQIUAABAAABAAAAAAEAAAEAAA
echo AAAAABAAAAAAAAAAAAAAAOApAABPAAAAAEAAAMwFAAAAAAAAAAAAAAAAAAAAAAAA
echo AGAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAIAAACAAAAAAAAAAAAAAACCAAAEgAAAAAAAAAAAAAAC50ZXh0AAAA
echo OAoAAAAgAAAADAAAAAIAAAAAAAAAAAAAAAAAACAAAGAucnNyYwAAAMwFAAAAQAAA
echo AAYAAAAOAAAAAAAAAAAAAAAAAABAAABALnJlbG9jAAAMAAAAAGAAAAACAAAAFAAA
echo AAAAAAAAAAAAAAAAQAAAQgAAAAAAAAAAAAAAAAAAAAAUKgAAAAAAAEgAAAACAAUA
echo tCEAACwIAAABAAAAAQAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAABMwAwBPAQAAAQAAEQACKAEAACsY/gQTBhEGLB8AcgEA
echo AHAoEAAACgByPwAAcCgQAAAKABcoEQAACgAAAhaaKBIAAAoKAheaKBIAAAoLcxMA
echo AAoMcxMAAAoNFhMHKxEIBhEHmm8UAAAKJhEHF1gTBxEHBigBAAAr/gQTCBEILd8W
echo EwkrEQkHEQmabxQAAAomEQkXWBMJEQkHKAEAACv+BBMKEQot33MVAAAKEwQABxML
echo FhMMKygRCxEMmhMNCBENbxYAAAoW/gETDhEOLAoRBBENbxcAAAoAEQwXWBMMEQwR
echo C45pMtBzFQAAChMFAAYTDxYTECsoEQ8REJoTEQkREW8WAAAKFv4BExIREiwKEQUR
echo EW8XAAAKABEQF1gTEBEQEQ+OaTLQcn0AAHAoGAAAChEEKBkAAAooGgAACgByjQAA
echo cCgYAAAKEQUoGQAACigaAAAKABYoEQAACgAqIgIoGwAACgAqQlNKQgEAAQAAAAAA
echo DAAAAHY0LjAuMzAzMTkAAAAABQBsAAAAYAIAACN+AADMAgAAMAMAACNTdHJpbmdz
echo AAAAAPwFAACgAAAAI1VTAJwGAAAQAAAAI0dVSUQAAACsBgAAgAEAACNCbG9iAAAA
echo AAAAAAIAAAFHFQIICQgAAAD6ATMAFgAAAQAAABgAAAACAAAAAgAAAAEAAAAbAAAA
echo DgAAAAEAAAACAAAAAQAAAAIAAAABAAAAAAD6AQEAAAAAAAYAbwG4AgYA3AG4AgYA
echo owCGAg8A2AIAAAYAywBGAgYAUgFGAgYAMwFGAgYAwwFGAgYAjwFGAgYAqAFGAgYA
echo 4gBGAgYAtwCZAgYAlQCZAgYAFgFGAgYA/QAMAgYAAgM1AgoADwA8AAYAGQA8AAoA
echo WwBYAgYAAQA8AAYAawA1AgYADgM1AgYAZgApAAYAJgI1AgAAAAAgAAAAAAABAAEA
echo AAAQAC0CcgJBAAEAAQBQIAAAAACRADwCmAABAKshAAAAAIYYgAIGAAIAAAABAPQC
echo CQCAAgEAEQCAAgYAGQCAAgoAKQCAAhAAMQCAAhAAOQCAAhAAQQCAAhAASQCAAhAA
echo UQCAAhAAWQCAAhAAYQCAAhUAaQCAAhAAcQCAAhAAeQCAAhAAmQAaA0QAqQBzAFMA
echo sQAJA1gAuQDnAl0ADACAAgYADABXAGkAFACAAgYADAD5AmkAFABXAHUAsQB9AHsA
echo wQBBAn8AuQAgA4kAgQCAAgYALgALAJ4ALgATAKcALgAbAMYALgAjAM8ALgArAOIA
echo LgAzAOIALgA7AOIALgBDAM8ALgBLAOgALgBTAOIALgBbAOIALgBjAAABLgBrACoB
echo LgBzADcBGgBjAG8ABIAAAAEAAAAAAAAAAAAAAAAAZAIAAAQAAAAAAAAAAAAAAI8A
echo MwAAAAAABAAAAAAAAAAAAAAAjwCJAAAAAAAfAE8AAAAASUVudW1lcmFibGVgMQBI
echo YXNoU2V0YDEATGlzdGAxADxNb2R1bGU+AFN5c3RlbS5JTwBtc2NvcmxpYgBTeXN0
echo ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYwBBZGQARW51bWVyYWJsZQBGaWxlAENvbnNv
echo bGUAV3JpdGVMaW5lAGdldF9OZXdMaW5lAFN5c3RlbS5Db3JlAEd1aWRBdHRyaWJ1
echo dGUARGVidWdnYWJsZUF0dHJpYnV0ZQBDb21WaXNpYmxlQXR0cmlidXRlAEFzc2Vt
echo Ymx5VGl0bGVBdHRyaWJ1dGUAQXNzZW1ibHlUcmFkZW1hcmtBdHRyaWJ1dGUAVGFy
echo Z2V0RnJhbWV3b3JrQXR0cmlidXRlAEFzc2VtYmx5RmlsZVZlcnNpb25BdHRyaWJ1
echo dGUAQXNzZW1ibHlDb25maWd1cmF0aW9uQXR0cmlidXRlAEFzc2VtYmx5RGVzY3Jp
echo cHRpb25BdHRyaWJ1dGUAQ29tcGlsYXRpb25SZWxheGF0aW9uc0F0dHJpYnV0ZQBB
echo c3NlbWJseVByb2R1Y3RBdHRyaWJ1dGUAQXNzZW1ibHlDb3B5cmlnaHRBdHRyaWJ1
echo dGUAQXNzZW1ibHlDb21wYW55QXR0cmlidXRlAFJ1bnRpbWVDb21wYXRpYmlsaXR5
echo QXR0cmlidXRlAGxpbmUtY29tcGFyZXIuZXhlAFN5c3RlbS5SdW50aW1lLlZlcnNp
echo b25pbmcAU3RyaW5nAFByb2dyYW0AU3lzdGVtAE1haW4ASm9pbgBTeXN0ZW0uUmVm
echo bGVjdGlvbgBTeXN0ZW0uTGlucQBsaW5lLWNvbXBhcmVyAGxpbmVfY29tcGFyZXIA
echo LmN0b3IAU3lzdGVtLkRpYWdub3N0aWNzAFN5c3RlbS5SdW50aW1lLkludGVyb3BT
echo ZXJ2aWNlcwBTeXN0ZW0uUnVudGltZS5Db21waWxlclNlcnZpY2VzAERlYnVnZ2lu
echo Z01vZGVzAFJlYWRBbGxMaW5lcwBhcmdzAENvbnRhaW5zAE9iamVjdABFeGl0AEVu
echo dmlyb25tZW50AENvdW50AFdyaXRlQWxsVGV4dAAAAAAAPUkAbgBjAG8AcgByAGUA
echo YwB0ACAAbgB1AG0AYgBlAHIAIABvAGYAIABhAHIAZwB1AG0AZQBuAHQAcwAuAAA9
echo RQB4ADoAIABsAGMALgBlAHgAZQAgAGYAaQBsAGUAMQAuAHQAeAB0ACAAZgBpAGwA
echo ZQAyAC4AdAB4AHQAAA9uAGUAdwAuAHQAeAB0AAAPbwBsAGQALgB0AHgAdAAAAAAA
echo Pkx1U7TSCE6/40pn/u8anQAEIAEBCAMgAAEFIAEBEREEIAEBDgQgAQECKQcTHQ4d
echo DhUSRQEOFRJFAQ4VEkkBDhUSSQEOAggCCAIdDggOAh0OCA4CChABAQgVElEBHgAD
echo CgEOBAABAQ4EAAEBCAUAAR0ODgUVEkUBDgUgAQITAAUVEkkBDgUgAQETAAMAAA4J
echo AAIODhUSUQEOBQACAQ4OCLd6XFYZNOCJBQABAR0OCAEACAAAAAAAHgEAAQBUAhZX
echo cmFwTm9uRXhjZXB0aW9uVGhyb3dzAQgBAAcBAAAAABIBAA1saW5lLWNvbXBhcmVy
echo AAAFAQAAAAAXAQASQ29weXJpZ2h0IMKpICAyMDE4AAApAQAkNDI4OWVhOTgtYmYy
echo Mi00ZDdkLWExZmEtZWVjYWMzNWI5YjZmAAAMAQAHMS4wLjAuMAAARwEAGi5ORVRG
echo cmFtZXdvcmssVmVyc2lvbj12NC4wAQBUDhRGcmFtZXdvcmtEaXNwbGF5TmFtZRAu
echo TkVUIEZyYW1ld29yayA0AAgqAAAAAAAAAAAAACIqAAAAIAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAUKgAAAAAAAAAAAAAAAF9Db3JFeGVNYWluAG1zY29yZWUuZGxsAAAA
echo AAD/JQAgQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIA
echo EAAAACAAAIAYAAAAUAAAgAAAAAAAAAAAAAAAAAAAAQABAAAAOAAAgAAAAAAAAAAA
echo AAAAAAAAAQAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAQABAAAAaAAAgAAAAAAAAAAA
echo AAAAAAAAAQAAAAAAzAMAAJBAAAA8AwAAAAAAAAAAAAA8AzQAAABWAFMAXwBWAEUA
echo UgBTAEkATwBOAF8ASQBOAEYATwAAAAAAvQTv/gAAAQAAAAEAAAAAAAAAAQAAAAAA
echo PwAAAAAAAAAEAAAAAQAAAAAAAAAAAAAAAAAAAEQAAAABAFYAYQByAEYAaQBsAGUA
echo SQBuAGYAbwAAAAAAJAAEAAAAVAByAGEAbgBzAGwAYQB0AGkAbwBuAAAAAAAAALAE
echo nAIAAAEAUwB0AHIAaQBuAGcARgBpAGwAZQBJAG4AZgBvAAAAeAIAAAEAMAAwADAA
echo MAAwADQAYgAwAAAAGgABAAEAQwBvAG0AbQBlAG4AdABzAAAAAAAAACIAAQABAEMA
echo bwBtAHAAYQBuAHkATgBhAG0AZQAAAAAAAAAAAEQADgABAEYAaQBsAGUARABlAHMA
echo YwByAGkAcAB0AGkAbwBuAAAAAABsAGkAbgBlAC0AYwBvAG0AcABhAHIAZQByAAAA
echo MAAIAAEARgBpAGwAZQBWAGUAcgBzAGkAbwBuAAAAAAAxAC4AMAAuADAALgAwAAAA
echo RAASAAEASQBuAHQAZQByAG4AYQBsAE4AYQBtAGUAAABsAGkAbgBlAC0AYwBvAG0A
echo cABhAHIAZQByAC4AZQB4AGUAAABIABIAAQBMAGUAZwBhAGwAQwBvAHAAeQByAGkA
echo ZwBoAHQAAABDAG8AcAB5AHIAaQBnAGgAdAAgAKkAIAAgADIAMAAxADgAAAAqAAEA
echo AQBMAGUAZwBhAGwAVAByAGEAZABlAG0AYQByAGsAcwAAAAAAAAAAAEwAEgABAE8A
echo cgBpAGcAaQBuAGEAbABGAGkAbABlAG4AYQBtAGUAAABsAGkAbgBlAC0AYwBvAG0A
echo cABhAHIAZQByAC4AZQB4AGUAAAA8AA4AAQBQAHIAbwBkAHUAYwB0AE4AYQBtAGUA
echo AAAAAGwAaQBuAGUALQBjAG8AbQBwAGEAcgBlAHIAAAA0AAgAAQBQAHIAbwBkAHUA
echo YwB0AFYAZQByAHMAaQBvAG4AAAAxAC4AMAAuADAALgAwAAAAOAAIAAEAQQBzAHMA
echo ZQBtAGIAbAB5ACAAVgBlAHIAcwBpAG8AbgAAADEALgAwAC4AMAAuADAAAADcQwAA
echo 6gEAAAAAAAAAAAAA77u/PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRG
echo LTgiIHN0YW5kYWxvbmU9InllcyI/Pg0KDQo8YXNzZW1ibHkgeG1sbnM9InVybjpz
echo Y2hlbWFzLW1pY3Jvc29mdC1jb206YXNtLnYxIiBtYW5pZmVzdFZlcnNpb249IjEu
echo MCI+DQogIDxhc3NlbWJseUlkZW50aXR5IHZlcnNpb249IjEuMC4wLjAiIG5hbWU9
echo Ik15QXBwbGljYXRpb24uYXBwIi8+DQogIDx0cnVzdEluZm8geG1sbnM9InVybjpz
echo Y2hlbWFzLW1pY3Jvc29mdC1jb206YXNtLnYyIj4NCiAgICA8c2VjdXJpdHk+DQog
echo ICAgICA8cmVxdWVzdGVkUHJpdmlsZWdlcyB4bWxucz0idXJuOnNjaGVtYXMtbWlj
echo cm9zb2Z0LWNvbTphc20udjMiPg0KICAgICAgICA8cmVxdWVzdGVkRXhlY3V0aW9u
echo TGV2ZWwgbGV2ZWw9ImFzSW52b2tlciIgdWlBY2Nlc3M9ImZhbHNlIi8+DQogICAg
echo ICA8L3JlcXVlc3RlZFByaXZpbGVnZXM+DQogICAgPC9zZWN1cml0eT4NCiAgPC90
echo cnVzdEluZm8+DQo8L2Fzc2VtYmx5PgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAADAAAADQ6AAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
echo AAAAAAAAAAAAAAAAAAAAAA==
echo -----END CERTIFICATE-----)>>Lc1.exe
certutil -decode LC1.exe LC.exe >nul
del /f /q Lc1.exe
goto backlc


:c
:color
Rem use:                             call :color HexColorCodeLikeInColorCommand "Text to say" /u(underline) /n(Does no create new like)
setlocal EnableDelayedExpansion
set "text=%~2"
set color=%1
set FG=%color:~-1%
set BG=%color:~0,1%
set Sameline=False
set Underline=False
if /i "%~3"=="/n" set Sameline=True
if /i "%~3"=="/u" set Underline=True
if /i "%~4"=="/n" set Newline=True
if /i "%~4"=="/u" set Underline=True


if /i "%FG%"=="0" set c1=30
if /i "%FG%"=="1" set c1=34
if /i "%FG%"=="2" set c1=32
if /i "%FG%"=="3" set c1=36
if /i "%FG%"=="4" set c1=31
if /i "%FG%"=="5" set c1=35
if /i "%FG%"=="6" set c1=33
if /i "%FG%"=="7" set c1=37
if /i "%FG%"=="8" set c1=90
if /i "%FG%"=="9" set c1=94
if /i "%FG%"=="a" set c1=92
if /i "%FG%"=="b" set c1=96
if /i "%FG%"=="c" set c1=91
if /i "%FG%"=="d" set c1=95
if /i "%FG%"=="e" set c1=93
if /i "%FG%"=="f" set c1=97

if /i "%BG%"=="0" set c2=40
if /i "%BG%"=="1" set c2=44
if /i "%BG%"=="2" set c2=42
if /i "%BG%"=="3" set c2=46
if /i "%BG%"=="4" set c2=41
if /i "%BG%"=="5" set c2=45
if /i "%BG%"=="6" set c2=43
if /i "%BG%"=="7" set c2=47
if /i "%BG%"=="8" set c2=100
if /i "%BG%"=="9" set c2=104
if /i "%BG%"=="a" set c2=102
if /i "%BG%"=="b" set c2=106
if /i "%BG%"=="c" set c2=101
if /i "%BG%"=="d" set c2=105
if /i "%BG%"=="e" set c2=103
if /i "%BG%"=="f" set c2=107

if %SameLine%==True call :NoNewLine & endlocal & exit /b

if %Underline%==False echo [%c1%m[%c2%m%Text%[0m
if %Underline%==True echo [4m[%c1%m[%c2%m%Text%[0m
endlocal
exit /b

:NoNewLine
if %Underline%==False echo|set /p="[%c1%m[%c2%m%Text%[0m"
if %Underline%==True echo|set /p="[4m[%c1%m[%c2%m%Text%[0m"
endlocal
exit /b
