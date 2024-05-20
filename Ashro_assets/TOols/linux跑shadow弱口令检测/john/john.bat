@echo off & setlocal EnableDelayedExpansion
rem 初次使用，请在此处修改JOHN软件run目录位置
set runpath=D:\soft\john-window\run

rem 定义字典文件名称，如字典未放在工具目录下则需添加路径
set zd=dict.txt
::set zd=jiancha.txt

rem 生成文件名列表和拷贝文件
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
del %runpath%\john.rec
rem del /s /q md
rem del /s /q mkdir
rem for /r %cd% %%a in (*.*) do echo %%~nxa >>%runpath%\filelist.txt
rem copy /y "%~dp0*.*" %runpath%
rem cls

rem 取目录名
rem set f=%~dp0
echo ###请选择扫描路径###
set /p f=你的选择:
for /r %f% %%a in (*.*) do echo %f%\%%~nxa >>%runpath%\filelist.txt
for /f "delims=" %%s in ("%f%") do (
set pathname=%%~ns
)
rem 设置结果存放路径
set newpath=C:\result
if not exist %newpath% (
set res=^>md %newpath%
@md %newpath% %res%
)
rem @del /q md

rem 取filelist.txt内容文件名
rem for /f %%i in (%runpath%\filelist.txt) do (
rem set filename=%%~nxi
rem )

rem 切换到run目录
rem Ping 127.0.0.1 –n 3 >nul
rem cd /d %runpath%

rem 选择模式
echo ###请选择扫描模式###
echo     1.简易模式
echo     2.字典模式
echo     3.混合模式（1+2）
echo     4.oracle模式
echo     5.format模式
echo     6.退出
set /p mode=你的选择:
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
title 正在使用single模式扫描%pathname%
echo 扫描模式:single 扫描文件:%pathname% > %newpath%\%pathname%-single-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo 正在扫描!a!:
echo %f%\%%~nxi : >> %newpath%\%pathname%-single-%D%.txt
%runpath%\john --single !a!  >> %newpath%\%pathname%-single-%D%.txt
echo. >> %newpath%\%pathname%-single-%D%.txt
rem del !a!
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
echo.
echo 扫描已完成！
echo %PATH%
::mshta vbscript:msgbox("扫描已完成！！！",64,"Auto Scan")(window.close)
pause
exit

:dic
for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-dic-%D%.txt
title 正在使用dic模式扫描%pathname%
echo 扫描模式:dic 扫描文件:%pathname% > %newpath%\%pathname%-dic-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo 正在扫描!a!:
echo %f%\%%~nxi : >> %newpath%\%pathname%-dic-%D%.txt

rem  !!!!!!!!此处更改字典文件！！！！！
%runpath%\john !a! --wordlist=%zd% >> %newpath%\%pathname%-dic-%D%.txt
echo. >> %newpath%\%pathname%-dic-%D%.txt
rem del !a!
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
echo.
echo 扫描已完成！
::mshta vbscript:msgbox("扫描已完成！！！",64,"Auto Scan")(window.close)
pause
exit

:ora
for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-ora-%D%.txt
title 正在使用ora模式扫描%pathname%
echo 扫描模式:ora 扫描文件:%pathname% > %newpath%\%pathname%-ora-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo 正在扫描!a!:
echo %f%\%%~nxi : >> %newpath%\%pathname%-ora-%D%.txt

rem  !!!!!!!!此处更改字典文件！！！！！
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
echo 扫描已完成！
::mshta vbscript:msgbox("扫描已完成！！！",64,"Auto Scan")(window.close)
pause
exit

:form

for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-form-%D%.txt
title 正在使用form模式扫描%pathname%
echo 扫描模式:form 扫描文件:%pathname% > %newpath%\%pathname%-form-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo 正在扫描!a!:
rem echo !a!: >>%f%\..\%filename%-form-%D%.txt
echo %f%\%%~nxi : >> %newpath%\%pathname%-form-%D%.txt

rem  !!!!!!!!此处更改字典文件！！！！！
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
rem del !a! rem 这里是删除filelist.txt里的内容
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
del %runpath%\john.rec
echo.
echo 扫描已完成！
::mshta vbscript:msgbox("扫描已完成！！！",64,"Auto Scan")(window.close)
pause
exit

:mix

for /f "tokens=1,2,3 delims=/- " %%a in ("%date%") do @set D=%%a-%%b-%%c
for /f "tokens=1,2,3 delims=:." %%a in ("%time%") do @set T=%%a-%%b-%%c
echo %date%%time% > %newpath%\%pathname%-mix-%D%.txt
title 正在使用mix模式扫描%pathname%
echo 扫描模式:mix 扫描文件:%pathname% > %newpath%\%pathname%-mix-%D%.txt
set j=0
for /f "delims=""" %%i in (%runpath%\filelist.txt) do (
set /a j+=1
set con!j!=%%i
call set a=%%con!j!%%
echo 正在扫描!a!:
rem echo !a!: >>%f%\..\%filename%-mix-%D%.txt
echo %f%\%%~nxi : >> %newpath%\%pathname%-mix-%D%.txt

rem  !!!!!!!!此处更改字典文件！！！！！
%runpath%\john --single !a! >> %newpath%\%pathname%-mix-%D%.txt
del %runpath%\john.pot
%runpath%\john --format=NT --wordlist=%zd% !a!  >> %newpath%\%pathname%-mix-%D%.txt
::%runpath%\john --wordlist=%zd% !a!  >> %newpath%\%pathname%-mix-%D%.txt
del %runpath%\john.pot
echo. >> %newpath%\%pathname%-mix-%D%.txt
rem del !a! rem 这里是删除filelist.txt里的内容
)
del %~dp0filelist.txt
del %runpath%\filelist.txt
del %runpath%\john.pot
del %runpath%\john.rec
echo.
echo 扫描已完成！
::mshta vbscript:msgbox("扫描已完成！！！",64,"Auto Scan")(window.close)
pause
exit

:quit
exit


