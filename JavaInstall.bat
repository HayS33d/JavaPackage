
::7001 - Already installed
::7009 - Failed Install
SET PRODVERSION=8.0.740.2
SET PRODGUID={26A24AE4-039D-4CA4-87B4-2F83218074F0}


for /f "tokens=8 delims=\" %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java 8" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS
for /f "tokens=8 delims=\" %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java 7" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS
for /f "tokens=8 delims=\" %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java 6" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS
for /f "tokens=8 delims=\" %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java(TM)" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS

for /f  %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java 8" ^| findstr "HKEY"') do call :RegDel %%a /f 
for /f  %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java 7" ^| findstr "HKEY"') do call :RegDel %%a /f 
for /f  %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java 6" ^| findstr "HKEY"') do call :RegDel %%a /f 
for /f  %%a in ('reg query hklm\software\wow6432node\microsoft\windows\currentversion\uninstall /s /f "Java(TM)" ^| findstr "HKEY"') do call :RegDel %%a /f 

::This will prevent the system mistaking 64 bit versions of Java as 32 bit versions on 32 bit operating systems.
IF %PROCESSOR_ARCHITECTURE%==AMD64 goto :Skip64Uninstall

for /f "tokens=7 delims=\" %%a in ('reg query hklm\software\microsoft\windows\currentversion\uninstall /s /f "Java 8" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS
for /f "tokens=7 delims=\" %%a in ('reg query hklm\software\microsoft\windows\currentversion\uninstall /s /f "Java 7" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS
for /f "tokens=7 delims=\" %%a in ('reg query hklm\software\Microsoft\windows\currentversion\uninstall /s /f "Java 6" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS
for /f "tokens=7 delims=\" %%a in ('reg query hklm\software\Microsoft\windows\currentversion\uninstall /s /f "Java(TM)" ^| findstr "HKEY"') do msiexec /x%%a /q REBOOT=REALLYSUPPRESS

for /f  %%a in ('reg query hklm\software\microsoft\windows\currentversion\uninstall /s /f "Java 8" ^| findstr "HKEY"') do call :RegDel %%a /f
for /f  %%a in ('reg query hklm\software\microsoft\windows\currentversion\uninstall /s /f "Java 7" ^| findstr "HKEY"') do call :RegDel %%a /f
for /f  %%a in ('reg query hklm\software\microsoft\windows\currentversion\uninstall /s /f "Java 6" ^| findstr "HKEY"') do call :RegDel %%a /f
for /f  %%a in ('reg query hklm\software\Microsoft\windows\currentversion\uninstall /s /f "Java(TM)" ^| findstr "HKEY"') do call :RegDel %%a /f
rmdir "C:\Program Files\Java\jre6" /s /q
rmdir "C:\Program Files\Java\jre7" /s /q

:Skip64Uninstall
rmdir "C:\Program Files (x86)\Java\jre6" /s /q
rmdir "C:\Program Files (x86)\Java\jre7" /s /q
del c:\windows\system32\java.exe
del c:\windows\system32\javaw.exe
del c:\windows\system32\javaws.exe
del c:\windows\syswow64\java.exe
del c:\windows\syswow64\javaw.exe
del c:\windows\syswow64\javaws.exe

taskkill /pid "msiexec.exe" /f

::ADD JAVA INSTALL COMMAND Line here
msiexec /i "%~dp0jre1.8.0_74.msi" /QN AUTOUPDATECHECK=0 IEXPLORER=1 JAVAUPDATE=0 JU=0 MOZILLA=1 REBOOT=REALLYSUPPRESS
mkdir C:\windows\sun
mkdir c:\windows\sun\java
mkdir c:\windows\sun\java\deployment
mkdir C:\windows\sun\java\deployment\security
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v SunJavaUpdateSched /f
reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /v SunJavaUpdateSched /f
REG QUERY HKLM\Software\microsoft\windows\currentversion\uninstall\%PRODGUID% /v DisplayVersion |find "%PRODVERSION%"
IF %ERRORLEVEL%==0 exit 0
REG QUERY HKLM\Software\wow6432Node\microsoft\windows\currentversion\uninstall\%PRODGUID% /v DisplayVersion |find "%PRODVERSION%"
IF %ERRORLEVEL%==0 exit 0
exit 7009
exit 0

:KillJava
set JAVAKEY=%1
reg delete %JAVAKEY% /f
goto :eof

:RegDel
echo %1 | find /I "uninstall" || goto :eof
reg delete %1 /f
goto :eof
