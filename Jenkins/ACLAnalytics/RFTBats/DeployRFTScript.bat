:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Description: Update cosmos automation for all users
:: Scheduled to run Thu&Mon at 5:00 AM
:: Developed by Steven Xiang 
:: Date: March 10, 2011
:: XCSWITCH /Y: Suppresses prompting to confirm you want to overwri existing destination file.
:: XCSWITCH /E: Copies directories and subdirectories, including empty ones. Same as /S /E. May be used to modify /T.
:: XCSWITCH /D: Copies files changed on or after the specified date.If no date is given, copies only those files whose source time is newer than the destination time.
:: XCSWITCH /R:  Overwrites read-only files.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF
:: Set our SRC and DES root folder
SET UPDATE_PROJECT=FALSE
SET PROJECT_NAME=QA_Automation_2012_V2.0_Monako
IF '%SRCROOT%'=='' SET SRCROOT=D:\ACL\TFSView\RFT_Automation\QA_Automation_2013_V2.0_GitHub
::SET SRCROOT_PRE=D:\ACL\TFSView\RFT_Automation\QA_Automation_2012_V2.0
SET BKFOLDER=D:\ACL\Automation\MyTestFramework_Backup
SET DESROOT=W:\%PROJECT_NAME%\ACL_User
SET DESROOT_PRE=W:\QA_Automation_2012_V2.0\ACL_User
SET DESBACKUP=W:\Backups\Automation_Dev
::SET DESBACKUP=G:\Project\QA_Automation_2012_V2.0
::SET TOAUTOTEST=DailyTest SmokeTest RegressionTest
SET XCSWITCH=/Y /E /D /R /EXCLUDE:.uploadExclude
SET XCSWITCH_=/Y /D /R /EXCLUDE:.uploadExclude
SET XCSCWITCH_REPLACE=/Y /R /E /I
::SET XCSWITCH_USER=/Y /E /D /R
::SET XCSWITCH=/Y /E /D /R
SET XCSWITCH_USER=%XCSWITCH%
::SET XCSWITCH_USER=%XCSWITCH%+.uploadExcludeForUser
::SET XCSWITCH_USER=%XCSWITCH%+.uploadExcludeForUser+.uploadExcludeDatapools
::SET uploadExcludeForUser=
SET FROMProject=ACLQA_Automation
SET UPLOADTO2=Steven
IF '%UPLOADTO1%'=='' SET UPLOADTO1=Development
:: Leave Steven4 for win7 - debug
SET TOUSER=%UPLOADTO2% Steven2 Steven3 Steven4 Iryna Yousef Kwok Jun Nahid
::SET TOUSER=%UPLOADTO2% Iryna Yousef Kwok Steven2 Danny
::SET TOPUBLIC=%UPLOADTO2% Iryna Yousef Sophia
SET FD1=D:\ACL\TFSView\SharedAutomationTestData\ACLProject
SET FD2=D:\ACL\JENKINS_HOME\userContent
SET FD3=
SET FD4=
SET FD5=
SET KD6=
SET FD7=


SET OUTPUT=%SRCROOT%.\updateScriptsLog.log
ECHO. Update at %DATE% - %TIME% > %OUTPUT%


:MAINMENU choose option from menu
CLS
ECHO. Start of xcopy...
ECHO. 
ECHO. Update Scripts from %SRCROOT%\%FROMProject%\ to %DESROOT%\[%TOUSER%\%FROMProject%]  >> %OUTPUT%
IF EXIST %SRCROOT%.\%UPLOADTO1%\%FROMProject% (
 PUSHD %SRCROOT%.\%UPLOADTO1%\%FROMProject%
 ) ELSE (
  PUSHD %SRCROOT%.\%FROMProject%
 )
::PAUSE
::ECHO. %FD1%  >> %OUTPUT%
::ECHO. %FD2%  >> %OUTPUT%
::ECHO. %FD3%  >> %OUTPUT%
::ECHO. %FD4%  >> %OUTPUT%
::ECHO. %FD5%  >> %OUTPUT%
::ECHO. %FD6%  >> %OUTPUT%
::ECHO. %FD7%  >> %OUTPUT%
::********** Update only*************
GOTO UPDate
::********************************************************************
::********** Copy from Development to user's folder only *************
::GOTO FILCOPY
::********************************************************************

:Backup
ECHO. Backup from %SRCROOT%.\%FROMProject%  to - %BKFOLDER%\%FROMProject%.  >> %OUTPUT%
IF Exist %BKFOLDER% XCOPY %SRCROOT%.\%FROMProject% %BKFOLDER%.\%PROJECT_NAME%.\%FROMProject%.\ %XCSWITCH%
IF Exist %DESBACKUP% XCOPY %SRCROOT%.\%FROMProject% %DESBACKUP%.\%PROJECT_NAME%.\%FROMProject%.\ %XCSWITCH%

::*********** Perform local backup only ******************************
::GOTO JOBDONE
::********************************************************************

:UPDate
::ECHO. Update from %FD1%.  to - %DESROOT%.\%UPLOADTO1%\AuditExchange.  >> %OUTPUT%
If /I '%UPDATE_PROJECT%'=='TRUE' (
   ECHO. XCOPY %SRCROOT%.\ACLQA_Automation\ACL_Desktop\DATA\KeywordTable %FD1%\BACKUP\KeywordTable\ %XCSWITCH%
   XCOPY %SRCROOT%.\ACLQA_Automation\ACL_Desktop\DATA\KeywordTable %FD1%\BACKUP\KeywordTable\ %XCSWITCH%
   ECHO. XCOPY %FD1% %DESROOT%.\..\SharedAutomationTestData\ACLProject\ %XCSWITCH%
   XCOPY %FD1% %DESROOT%.\..\SharedAutomationTestData\ACLProject\ %XCSWITCH%
   XCOPY %FD2% %DESROOT%.\..\SharedAutomationTestData\Jenkins\ACLAnalytics\ %XCSWITCH%
   )
ECHO. Update from %SRCROOT%.\%FROMProject%.  to - %DESROOT%.\%UPLOADTO1%\%FROMProject%.  >> %OUTPUT%
XCOPY %SRCROOT%.\%FROMProject% %DESROOT%.\%UPLOADTO1%\%FROMProject%.\ %XCSWITCH%

::*********** Update Development Only ******************************
::GOTO JOBDONE
::******************************************************************

:FILCOPY
::Update user's scripts remotely, but very slow, so do it if needed - Steven.
ECHO. F | XCOPY %DESROOT_PRE%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\updateACLDailyBuild.bat %DESROOT%.\ACLSilentInstaller.bat %XCSWITCH_%
ECHO. F | XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\updateACLDailyBuild.bat %DESROOT%.\updateACLDailyBuild.bat %XCSWITCH_%
ECHO. F | XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\AutoTest_ACLSCripts.bat %DESROOT%.\AutoTest_ACLSCripts.bat %XCSWITCH_%
ECHO. F | XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\updateACLDailyBuild.bat %DESROOT%.\update_DT_IH_Build.bat %XCSWITCH_%
REM XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\SilentInstallation_32bit_ACLv93.bat %DESROOT%.\ %XCSWITCH_%
REM XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\SilentInstallation_64bit_ACLv93.bat %DESROOT%.\ %XCSWITCH_%
XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\lib\acl\tool\autoTest.bat %DESROOT%.\ %XCSWITCH_%
XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%.\ACL_Desktop\DATA\KeywordTable\batchRunData.xls %DESROOT%.\ %XCSWITCH_%
FOR %%U IN (%TOUSER%) DO IF NOT '%%U'=='' XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject% %DESROOT%.\%%U.\%FROMProject%.\ %XCSWITCH_USER%
REM If /I '%UPDATE_PROJECT%'=='TRUE' (
REM   XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%\ACL_Desktop\DATA\ACLProject\BACKUP %ACL_Project%.\ %XCSWITCH%
REM   FOR %%U IN (%TOAUTOTEST%) DO IF NOT '%%U'=='' XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject%\ACL_Desktop\DATA\ACLProject\BACKUP %DESROOT%.\%%U.\%FROMProject%.\ACL_Desktop\DATA\ACLProject\BACKUP\ %XCSWITCH%
REM   )

::FOR %%U IN (%TOPUBLIC%) DO IF NOT '%%U'=='' XCOPY %DESROOT%.\%UPLOADTO1%\%FROMProject% %DESROOT%.\%%U.\%FROMProject%.\ %XCSWITCH_USER%
::FOR %%U IN (%TOPUBLIC%) DO IF NOT '%%U'=='' XCOPY %DESROOT%.\%UPLOADTO1%\AuditExchange %DESROOT%.\%%U.\AuditExchange.\ %XCSWITCH% 


:QUIT no further action

:JOBDONE
ECHO. Xcopy done!  >> %OUTPUT%
GOTO CLEANUP

:E_FOLDER folder not found
ECHO. Finished with some errors %errorlevel%  >> %OUTPUT%
GOTO CLEANUP

:CLEANUP
TYPE %OUTPUT%
SET SRCROOT=
SET DESROOT=
SET XCSWITCH=
SET XCSWITCH_=
SET XCSWITCH_USEER=
SET TOPUBLIC=
SET FROMProject=
SET FD1=
SET FD2=
SET FD3=
SET FD4=
SET FD5=
SET FD6=
SET FD7=
SET TOUSER=
SET BKFOLDER=
SET BKDIR=
SET OUTPUT=
SET UPLOADTO1=
SET UPLOADTO2=
GOTO EOF (end-of-file)


:EOF (end-of-file)
ECHO. End of xcopy
PAUSE
