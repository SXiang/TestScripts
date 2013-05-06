@ECHO OFF
:Email
"%JENKINS_HOME%"\userContent\sleep 5 /quiet
Rem ECHO. BUILD_URL='%BUILD_URL%' JENKINS_URL='%JENKINS_URL%'
IF /I '%strFileURL%'=='' set strFileURL=%BUILD_URL%../
SET reportDir=%WORKSPACE%.\TestReport
set strHDLocation=%ReportDir%\JenkinsReport.html
rem set strHDLocation=C:\ACL\CI_Jenkins\JenkinsReport.html
mkdir -p %ReportDir% m>NUL 2>$1
Rem cd C:\WINDOWS\GnuWin32\bin
rem IF '%BUILD_STATUS%'=='' SET BUILD_STATUS=Success -- IT'S a tag name from email-ext, doesn't work here
SET subject= Jenkins Test (Beta) - ACL Analytics [%Version%]
Echo wget.exe --no-proxy --wait=5 --tries=3 -S --timeout=600 -O %strHDLocation% %strFileURL%
Call wget.exe --no-proxy --wait=5 --tries=3 -S --timeout=600 -O %strHDLocation% %strFileURL%
Echo Call Cscript "%WORKSPACE%"\rftbats\getHttpContent.vbs %strFileURL% %strHDLocation% %JENKINS_URL% %strFileURL% "%subject%"
Call Cscript "%WORKSPACE%"\rftbats\getHttpContent.vbs %strFileURL% %strHDLocation% %JENKINS_URL% %strFileURL% "%subject%"

SET strHDLocation=%strHDLocation%email.html
IF Not Exist %strHDLocation% GOTO End
		ECHO.fromAddress=%USER_NAME%@ACL.COM>>userProperties
		ECHO.fromName=%USER_NAME%>>userProperties
		ECHO.userName=ACL\%USER_NAME%>>userProperties
		ECHO.subject=%subject%>>userProperties
rem		ECHO.fromAddress=QAMail@ACL.COM
rem     ECHO.userName=ACL\QAMAIL
rem		ECHO.fromAddress=QAMAIL@ACL.COM
rem		ECHO.romName=QAMAIL
Rem		ECHO.toAddress=%USER_NAME%@ACL.com
		ECHO.body=%strHDLocation%>>userProperties
		ECHO.attachFiles>>userProperties
Rem		ECHO.ccAddress=
Rem		ECHO.bccAddress=
:END
EXIT 0