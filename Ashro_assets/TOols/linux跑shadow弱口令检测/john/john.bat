@echo off & setlocal EnableDelayedExpansion
rem ����ʹ�ã����ڴ˴��޸�JOHN���runĿ¼λ��
set runpath=D:\soft\john-window\run

rem �����ֵ��ļ����ƣ����ֵ�δ���ڹ���Ŀ¼���������·��
set zd=dict.txt
::set zd=jiancha.txt

rem �����ļ����б�Ϳ����ļ�
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
del %runpath%\john.rec
rem del /s /q md
rem del /s /q mkdir
rem for /r %cd% %%a in (*.*) do echo %%~nxa >>%runpath%\filelist.txt
rem copy /y "%~dp0*.*" %runpath%
rem cls

rem ȡĿ¼��
rem set f=%~dp0
echo ###��ѡ��ɨ��·��###
set /p f=���ѡ��:
for /r %f% %%a in (*.*) do echo %f%\%%~nxa >>%runpath%\filelist.txt
for /f "delims=" %%s in ("%f%") do (
set pathname=%%~ns
)
rem ���ý�����·��
set newpath=C:\result
if not exist %newpath% (
set res=^>md %newpath%
@md %newpath% %res%
)
rem @del /q md

rem ȡfilelist.txt�����ļ���
rem for /f %%i in (%runpath%\filelist.txt) do (
rem set filename=%%~nxi
rem )

rem �л���runĿ¼
rem Ping 127.0.0.1 �Cn 3 >nul
rem cd /d %runpath%

rem ѡ��ģʽ
echo ###��ѡ��ɨ��ģʽ###
echo     1.����ģʽ
echo     2.�ֵ�ģʽ
echo     3.���ģʽ��1+2��
echo     4.oracleģʽ
echo     5.formatģʽ
echo     6.�˳�
set /p mode=���ѡ��:
if %mode%==1 goto single
if %mode%==2 goto dic
if %mode%==3 goto mix
if %mode%==4 goto ora
if %mode%==5 goto form
if %mode%==6 goto quit

:single
for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-single-%D%.txt
title ����ʹ��singleģʽɨ��%pathname%
echo ɨ��ģʽ:single ɨ���ļ�:%pathname% > %newpath%\%pathname%-single-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo ����ɨ��!a!:
echo %f%\%%~nxi : >> %newpath%\%pathname%-single-%D%.txt
%runpath%\john --single !a!  >> %newpath%\%pathname%-single-%D%.txt
echo. >> %newpath%\%pathname%-single-%D%.txt
rem del !a!
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
echo.
echo ɨ������ɣ�
echo %PATH%
::mshta vbscript:msgbox("ɨ������ɣ�����",64,"Auto Scan")(window.close)
pause
exit

:dic
for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-dic-%D%.txt
title ����ʹ��dicģʽɨ��%pathname%
echo ɨ��ģʽ:dic ɨ���ļ�:%pathname% > %newpath%\%pathname%-dic-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo ����ɨ��!a!:
echo %f%\%%~nxi : >> %newpath%\%pathname%-dic-%D%.txt

rem  !!!!!!!!�˴������ֵ��ļ�����������
%runpath%\john !a! --wordlist=%zd% >> %newpath%\%pathname%-dic-%D%.txt
echo. >> %newpath%\%pathname%-dic-%D%.txt
rem del !a!
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
echo.
echo ɨ������ɣ�
::mshta vbscript:msgbox("ɨ������ɣ�����",64,"Auto Scan")(window.close)
pause
exit

:ora
for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-ora-%D%.txt
title ����ʹ��oraģʽɨ��%pathname%
echo ɨ��ģʽ:ora ɨ���ļ�:%pathname% > %newpath%\%pathname%-ora-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo ����ɨ��!a!:
echo %f%\%%~nxi : >> %newpath%\%pathname%-ora-%D%.txt

rem  !!!!!!!!�˴������ֵ��ļ�����������
%runpath%\john --format=oracle --single !a! >> %newpath%\%pathname%-ora-%D%.txt
del %runpath%\john.pot
%runpath%\john --format=oracle --wordlist=%zd% !a! >> %newpath%\%pathname%-ora-%D%.txt
del %runpath%\john.pot
%runpath%\john --format=oracle11 --single !a! >> %newpath%\%pathname%-ora-%D%.txt
del %runpath%\john.pot
%runpath%\john --format=oracle11 --wordlist=%zd% !a! >> %newpath%\%pathname%-ora-%D%.txt
del %runpath%\john.pot
echo. >> %newpath%\%pathname%-ora-%D%.txt
rem del !a!
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
echo.
echo ɨ������ɣ�
::mshta vbscript:msgbox("ɨ������ɣ�����",64,"Auto Scan")(window.close)
pause
exit

:form

for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-form-%D%.txt
title ����ʹ��formģʽɨ��%pathname%
echo ɨ��ģʽ:form ɨ���ļ�:%pathname% > %newpath%\%pathname%-form-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo ����ɨ��!a!:
rem echo !a!: >>%f%\..\%filename%-form-%D%.txt
echo %f%\%%~nxi : >> %newpath%\%pathname%-form-%D%.txt

rem  !!!!!!!!�˴������ֵ��ļ�����������
rem %runpath%\john --single !a! >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
rem %runpath%\john --wordlist=%zd% !a!  >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
rem %runpath%\john --format=md5 !a!  >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
%runpath%\john --format=bf --wordlist=%zd% -rules !a! >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
rem %runpath%\john --format=bsdi !a!  >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
rem %runpath%\john --format=crypt !a!  >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
rem %runpath%\john --format=des !a!  >> %newpath%\%pathname%-form-%D%.txt
rem del %runpath%\john.pot
echo. >> %newpath%\%pathname%-form-%D%.txt
rem del !a! rem ������ɾ��filelist.txt�������
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
del %runpath%\john.rec
echo.
echo ɨ������ɣ�
::mshta vbscript:msgbox("ɨ������ɣ�����",64,"Auto Scan")(window.close)
pause
exit

:mix

for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-mix-%D%.txt
title ����ʹ��mixģʽɨ��%pathname%
echo ɨ��ģʽ:mix ɨ���ļ�:%pathname% > %newpath%\%pathname%-mix-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo ����ɨ��!a!:
rem echo !a!: >>%f%\..\%filename%-mix-%D%.txt
echo %f%\%%~nxi : >> %newpath%\%pathname%-mix-%D%.txt

rem  !!!!!!!!�˴������ֵ��ļ�����������
%runpath%\john --single !a! >> %newpath%\%pathname%-mix-%D%.txt
del %runpath%\john.pot
%runpath%\john --format=NT --wordlist=%zd% !a!  >> %newpath%\%pathname%-mix-%D%.txt
::%runpath%\john --wordlist=%zd% !a!  >> %newpath%\%pathname%-mix-%D%.txt
del %runpath%\john.pot
echo. >> %newpath%\%pathname%-mix-%D%.txt
rem del !a! rem ������ɾ��filelist.txt�������
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
del %runpath%\john.rec
echo.
echo ɨ������ɣ�
::mshta vbscript:msgbox("ɨ������ɣ�����",64,"Auto Scan")(window.close)
pause
exit

:quit
exit


