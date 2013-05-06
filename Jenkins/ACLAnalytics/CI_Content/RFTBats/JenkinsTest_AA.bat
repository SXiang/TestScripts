@ECHO OFF
Rem schedulerCMD: USER_NAME PASSWORD ACL Latest TEST_UNICODE TEST_NONUNICODE TEST_TYPE tFolder
IF NOT EXIST %SRCROOT% NET USE %SRCROOT% "%PASSWORD%" /USER:"ACL\%USER_NAME%" /P:Yes
IF NOT EXIST %MISSINGDLLSSRC% NET USE %MISSINGDLLSSRC% "%PASSWORD%" /USER:"ACL\%USER_NAME%" /P:Yes

IF "%WORKSPACE%"=="" SET WORKSPACE=%JENKINS_HOME%\userContent

IF NOT EXIST %RFT_PROJECT_LOCATION% SET RFT_PROJECT_LOCATION=%WORKSPACE%.\..\%RFT_PROJECT_LOCATION%
IF NOT EXIST %RFT_PROJECT_LOCATION% SET RFT_PROJECT_LOCATION=D:\ACL\TFSView\RFT_Automation\QA_Automation_2013_V2.0_GitHub\ACLQA_Automation
SET ScriptDir=%RFT_PROJECT_LOCATION%\lib\acl\tool
SET ScriptDirTest=%WORKSPACE%\RFTBats
::PUSHD C:%HOMEPATH%\IBM\rationalsdp
IF NOT '%RFT_DATAPOOL_NAME%'=='' SET RFT_DATAPOOL_NAME=%WORKSPACE%.\%RFT_DATAPOOL_NAME%
IF '%WHICH%'=='' SET WHICH=Unicode
IF /I '%WHICH%'=='Unicode' SET TEST_UNICODE=Yes
IF /I '%WHICH%'=='Unicode' SET TEST_NONUNICODE=No
IF /I '%WHICH%'=='Release' SET TEST_NONUNICODE=Yes
IF /I '%WHICH%'=='Release' SET TEST_UNICODE=No

REM default inputs
IF '%USER_NAME%'=='' SET USER_NAME=QAMail
IF '%PASSWORD%'=='' SET PASSWORD=Password00
IF '%DOMAIN_NAME%'=='' SET DOMAIN_NAME=ACL
IF '%TEST_BUILD%'=='' SET TEST_BUILD=BUILD_149
IF '%TEST_UNICODE%'=='' SET TEST_UNICODE=No
IF '%TEST_NONUNICODE%'=='' SET TEST_NONUNICODE=No
IF '%TEST_CATEGORY%'=='' SET TEST_CATEGORY=Daily
IF '%PROJECT_TYPE%'=='' SET PROJECT_TYPE=LOCALONLY
IF '%tFolder%'=='' SET tFolder=Dev

REM from calling script
IF NOT '%1'=='' SET USER_NAME=%1
IF NOT '%2'=='' SET PASSWORD=%2
IF NOT '%3'=='' SET DOMAIN_NAME=%3
IF NOT '%4'=='' SET TEST_BUILD=%4
IF NOT '%5'=='' SET TEST_UNICODE=%5
IF NOT '%6'=='' SET TEST_NONUNICODE=%6
IF NOT '%7'=='' SET TEST_CATEGORY=%7
IF NOT '%8'=='' SET PROJECT_TYPE=%8
IF NOT '%9'=='' SET tFolder=%9

SET reportDir=%WORKSPACE%\TestReport
REM SET redir=%reportDir%\%Version%-%WHICH%
SET redir=%WORKSPACE%\..\TestHistory\%Version%-%WHICH%

IF /I '%NewBuildOnly%'=='Yes' (
  ECHO.Check test history '%redir%'
  IF EXIST %redir% GOTO Skip
)
IF /I '%verType%'=='Install' GOTO Install
IF /I '%verType%'=='Copy' GOTO GetBuild
IF /I '%verType%'=='Current' GOTO RUN
IF Exist %tFolder% GOTO RUN
rem set desroot=D:\ACL\JENKINS_HOME\jobs\DailyTest_AA_Unicode\workspace\ACLAnalytics
REM IF NOT EXIST %SRCROOT% NET USE %SRCROOT% "%PASSWORD%" /USER:"ACL\%USER_NAME%" /P:Yes
REM IF NOT EXIST %MISSINGDLLSSRC% NET USE %MISSINGDLLSSRC% "%PASSWORD%" /USER:"ACL\%USER_NAME%" /P:Yes
REM goto run
:GetBuild
SET DESROOT=%WORKSPACE%\ACLAnalytics
SET XCSWITCH=/Y /E /R /I
IF NOT EXIST %SRCROOT%\%Version%\%WHICH%\ACLWin.exe %ScriptDir%\sleep 30 /quiet
START "" /B /WAIT XCOPY %MISSINGDLLSSRC% %DESROOT%\%WHICH%\ %XCSWITCH%>NUL
START "" /B /WAIT XCOPY %SRCROOT%\%Version%\%WHICH% %DESROOT%\%WHICH%\ %XCSWITCH%>NUL
SET tFolder=%DESROOT%\%WHICH%\ACLWin.exe
IF NOT EXIST %tFolder% %ScriptDir%\sleep 10 /quiet
IF NOT EXIST %tFolder% GOTO Error
GOTO Run
:Install
SET XCSWITCH_=/Y /R /I
SET DESROOT=%tFolder%\%WHICH%
SET INSTALLEXE=ACLv10En_%WHICH%.exe
SET Executable=ACLWin.exe
SET tFolder=%DESROOT%\%Executable%
SET INSTALL_DIR=%DESROOT%
   TASKKILL /F /T /IM %Executable% 2>NUL
   TASKKILL /F /T /IM %INSTALLEXE% 2>NUL
rem   IF EXIST %DESROOT%\%Executable% (
rem	  %DESROOT%\%VerType%\%INSTALLEXE% /s /a /x /s /v"/qb /passive /quiet /l* \"%DESROOT%\%VerType%\Uninstallation.log\"" 2>NUL
rem   )   
   RMDIR /S /Q %DESROOT%.\%VerType% 2>NUL
   MKDIR %DESROOT%.\%VerType%\%Version%	2>NUL
rem   ECHO. XCOPY %SRCROOT%\%Version%\Installer\%INSTALLEXE% %DESROOT%\%VerType%\%INSTALLEXE% %XCSWITCH_%
   ECHO. F | XCOPY %SRCROOT%\%Version%\Installer\%INSTALLEXE% %DESROOT%\%VerType%\%INSTALLEXE% %XCSWITCH_%
   ECHO. %DESROOT%\%VerType%\%INSTALLEXE% /s /a /s /v"/qb /passive /quiet PIDKEY=CAW1234567890 COMPANYNAME=\"ACLQA Automation\" INSTALLDIR=\"%INSTALL_DIR%\" /l* \"%INSTALL_DIR%\%VerType%\Installation.log\""
   %DESROOT%\%VerType%\%INSTALLEXE% /s /a /s /v"/qb /passive /quiet PIDKEY=CAW1234567890 COMPANYNAME=\"ACLQA Automation\" INSTALLDIR=\"%INSTALL_DIR%\" /l* \"%INSTALL_DIR%\%VerType%\Installation.log\""
   TYPE "%INSTALL_DIR%\%VerType%\Installation.log"
GOTO Run
:Run
::GOTO SKIP
IF EXIST %reportDir%.\FinishedTest rmdir /S /Q %reportDir%.\FinishedTest
mkdir -p %ReportDir% >NUL 2>$1
START "Run Jenkins Job" /B /WAIT /D"%ScriptDirTest%" JenkinsTest.bat %USER_NAME% %PASSWORD% %DOMAIN_NAME% %TEST_BUILD% %TEST_UNICODE% %TEST_NONUNICODE% %TEST_CATEGORY% %PROJECT_TYPE% %tFolder%
REM goto DONE

:SETTIME
SET /a period=5*60
IF /I '%TEST_CATEGORY%'=='Daily' (
   SET /a wait=3*60*60
) ELSE IF /I '%TEST_CATEGORY%'=='Smoke' (
   SET /a wait=10*60*10
) ELSE IF /I '%TEST_CATEGORY%'=='Regression' (
   SET /a wait=20*60*60
) ELSE (
   SET /a wait=5*60*60
) 
Rem Debug ...
SET /a wait=5*60*60
SET /a period=1*60

:WAIT
IF EXIST %reportDir%.\FinishedTest GOTO DONE
%ScriptDir%\sleep %period% /quiet
SET /a elapsed=elapsed+%period%
IF elapsed GTR wait (
  ECHO. Error: test not finished in %wait% seconds, check the log for details !
  GOTO DONE
) ELSE (
  GOTO WAIT
)
:DONE
ECHO Test Completed!!!

%ScriptDir%\sleep 5 /quiet
GOTO EOF
:Error
Echo Failed to deploye %Version% to %DESROOT%\%WHICH%\ for testing, check it out!
GOTO EOF
:Skip
Echo This build had been tested  on this machine: %Version%-%WHICH% in previous jenkins job, test skiped!> %ReportDir%\test_summary.html
GOTO EOF
:EOF
EXIT 0
EXIT 0

