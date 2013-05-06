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
IF '%BUILD_STATUS%'=='' SET BUILD_STATUS=Unknown
SET subject= Jenkins Test (Beta) - ACL Analytics [%Version%] - %BUILD_STATUS%
Echo wget.exe --no-proxy --wait=5 --tries=3 -S --timeout=600 -O %strHDLocation% %strFileURL%
Call wget.exe --no-proxy --wait=5 --tries=3 -S --timeout=600 -O %strHDLocation% %strFileURL%
Echo Call Cscript "%WORKSPACE%"\rftbats\getHttpContent.vbs %strFileURL% %strHDLocation% %JENKINS_URL% %strFileURL% "%subject%"
Call Cscript "%WORKSPACE%"\rftbats\getHttpContent.vbs %strFileURL% %strHDLocation% %JENKINS_URL% %strFileURL% "%subject%"

SET strHDLocation=%strHDLocation%email.html
IF Not Exist %strHDLocation% GOTO End
        SET smtpServer=xchg-cas-array.acl.com
rem		SET smtpServer=192.168.10.240
		SET fromAddress=%USER_NAME%@ACL.COM
		SET fromName=%USER_NAME%
		SET userName=ACL\%USER_NAME%
		SET password=%PASSWORD%
rem		SET fromAddress=QAMail@ACL.COM
rem        SET userName=ACL\QAMAIL
rem		SET password=Password00
rem		SET fromAddress=QAMAIL@ACL.COM
rem		SET fromName=QAMAIL
Rem		SET toAddress=%USER_NAME%@ACL.com
		SET body=%strHDLocation%
		SET attachFiles=
Rem		SET ccAddress=
Rem		SET bccAddress=
		SET importance=Normal
		
		SET ipPort=25
rem		set ipPort=587
		SET ssl=1
		SET d=,
		set s= 
echo. "%WORKSPACE%"\rftbats\CDOMessage.exe %subject%%d%%smtpServer%%d%%fromName%%d%%fromAddress%%d%%toAddress%%d%%body%%d%%attachFiles%%d%%ccAddress%%d%%bccAddress%%d%%importance%%d%%userName%%d%%password%%d%%ipPort%%d%%ssl%
SET emailCmd=%subject%%d%%smtpServer%%d%%fromName%%d%%fromAddress%%d%%toAddress%%d%%body%%d%%attachFiles%%d%%ccAddress%%d%%bccAddress%%d%%importance%%d%%userName%%d%%password%%d%%ipPort%%d%%ssl%
Call "%WORKSPACE%"\rftbats\CDOMessage.exe %emailCmd%

:END
EXIT 0