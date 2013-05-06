@ECHO OFF
IF NOT '%1'=='' SET tFolder=%1

IF '%tFolder%'=='' SET tFolder=RC
IF '%VerPrefix%'=='' SET VerPrefix=Build_
IF /I '%tFolder%'=='Dev' SET VerPrefix=%VerPrefix%2

IF '%SRCROOT%'=='' SET SRCROOT=\\biollante02\DailyBuild\Monaco
IF /I '%TEST_BUILD%'=='Latest' GOTO GET
IF NOT '%REVISION_NUM%'=='' GOTO ENV
IF '%TEST_BUILD%'=='' GOTO GET
IF /I '%tFolder%'=='Dev' GOTO GET
IF /I '%tFolder%'=='RC' GOTO GET
GOTO EOF
:GET
SET SRCROOT=%SRCROOT%\%tFolder%
SET NUM_TOKENS=5
SET DOMAIN_NAME=ACL

IF EXIST %tFolder% SET Version=%TEST_BUILD%
IF EXIST %tFolder% GOTO ENV

if '%LatestVer%'=='' SET LatestVer=0
FOR /D  %%g IN (%SRCROOT%\%VerPrefix%*) DO (
    FOR /F "eol=. tokens=%NUM_TOKENS% usebackq delims=\" %%f IN ('%%g') DO (
	   IF /I '%%f' GTR '%VerPrefix%999' (
	      ECHO 
       ) ELSE IF /I '%%f' EQU '%VerPrefix%8_2012-10-12_14-12-34' (
	      ECHO 
       ) ELSE IF /I '%%f' EQU '%VerPrefix%9_2012-10-12_15-34-22' (
	      ECHO 
       ) ELSE IF /I '%%f' LSS '%VerPrefix%000' (
	      ECHO 
       ) ELSE IF /I '%LatestVer%' LEQ '%%f' (
	      SET LatestVer=%%f
	   )
    )   
)


SET Version=%_Version%
IF '%Version%'=='' SET Version=%LatestVer%
IF /I '%Version%'=='Latest' SET Version=%LatestVer%

:ENV
IF NOT '%REVISION_NUM%'=='' (
 SET Version=BUILD_%REVISION_NUM%
 SET aclBatchs=\\Biollante02\Batches
 SET SRCROOT=%SRCROOT%\%tFolder%
 )
IF /I '%verType%'=='Install' (
 SET tFolder=C:\ACL\CI_Jenkins\Analytics10
)
SET XCSWITCH=/Y /E /R /I

SET userProp="%JENKINS_HOME%"\userContent\user.properties
SET reportDir="%WORKSPACE%"\TestReport
SET strHDLocation=%ReportDir%\JenkinsReport.html

Echo.TEST_BUILD=%Version%> %userProp%
ECHO.Version=%Version%>> %userProp%
ECHO.MISSINGDLLSSRC=\\winrunner\winrunner\SharedFiles\ACL_missing_Files>> %userProp%
ECHO.SRCROOT=%SRCROOT%>> %userProp%
ECHO.tFolder=%tFolder%>> %userProp%
ECHO.NewBuildOnly=%NewBuildOnly%>> %userProp%
Rem ECHO.USER_NAME=%USER_NAME%>> %userProp%
Rem ECHO.PASSWORD=%PASSWORD%>> %userProp%
Echo.AA_BUILD=%Version:~6%>> %userProp%
Echo.BUILD_ID=%BUILD_ID%>> %userProp%
Echo.ToAddress=%ToAddress%>> %userProp%
Echo.CcAddress=%CcAddress%>> %userProp%
Echo.BccAddress=%BccAddress%>> %userProp%
Echo.strHDLocation=%strHDLocation%>> %userProp%
Echo.strFileURL=%BUILD_URL%../>> %userProp%
Echo.aclBatchs=%aclBatchs%>> %userProp%
Echo.REVISION_NUM=%REVISION_NUM%>> %userProp%
Echo.verType=%verType%>> %userProp%
::Echo.comm=XCOPY %userProp% %WORKSPACE%\ %XCSWITCH% >> %userProp%
XCOPY %userProp% "%WORKSPACE%"\ %XCSWITCH% 2>NUL


:EOF
EXIT 0