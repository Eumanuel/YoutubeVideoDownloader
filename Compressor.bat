set reg50=::&set reg51=::&(reg /?>nul 2>&1 && set reg51=)
if %errorlevel%==5005 set reg50=
set qkey=HKEY_CURRENT_USER\Console&set qprop=QuickEdit
%reg51%if defined qedit_val (echo y|reg add "%qkey%" /v "%qprop%" /t REG_DWORD /d %qedit_val%&goto :mainstart)
%reg50%if defined qedit_val (reg update "%qkey%\%qprop%"=%qedit_val%&goto :mainstart)
%reg51%for /f "tokens=3*" %%i in ('reg query "%qkey%" /v "%qprop%" ^| FINDSTR /I "%qprop%"') DO set qedit_val=%%i
%reg50%for /f "tokens=3*" %%i in ('reg query "%qkey%\%qprop%"') DO set qedit_val=%%i
if "%qedit_val%"=="0" goto :mainstart
if "%qedit_val%"=="0x0" goto :mainstart
%reg51%echo y|reg add "%qkey%" /v "%qprop%" /t REG_DWORD /d 0
%reg50%if "%qedit_val%"=="" reg add "%qkey%\%qprop%"=0 REG_DWORD
%reg50%if "%qedit_val%"=="1" reg update "%qkey%\%qprop%"=0
start "" "cmd" /c set qedit_val=%qedit_val% ^& call "%~dpnx0"&exit
:mainstart
@echo off
cd bin
cls
setlocal EnableDelayedExpansion
set "FileName=""
echo Solte o video aqui
echo.
set /P "FileName=File name: "
set "FileName=!FileName:"=!"
set "FileFinal=!FileName!
cls
echo Como você quer o arquivo final?
echo.
echo 1- Compressao padrao (Rapida)
echo 2- Arquivo .mp3
echo 3- Compressao Youtube (Muito Lenta)
set /P type="Opcao: "
GOTO !type!
:1
if not "!FileName!" == "" (
	cls
	echo Qualidade da compressao:
	echo.
	echo 1- Automatico
	echo 2- Baixo 		700Kbps
	echo 3- Medio		1200Kbps
	echo 4- Alto 		2000kbps
	echo 5- Personalizado
	set /P qlt="Qualidade: "
	set "FileFinal=!FileFinal:.mp4=! - Compressed
	if "!qlt!" == "1" (ffmpeg -i "!FileName!" -vcodec h264_nvenc -acodec mp3 "!FileFinal!".mp4)
	if "!qlt!" == "2" (ffmpeg -i "!FileName!" -vcodec h264_nvenc -b:v 700k -acodec mp3 "!FileFinal!".mp4)
	if "!qlt!" == "3" (ffmpeg -i "!FileName!" -vcodec h264_nvenc -b:v 1200k -acodec mp3 "!FileFinal!".mp4)
	if "!qlt!" == "4" (ffmpeg -i "!FileName!" -vcodec h264_nvenc -b:v 2000k -acodec mp3 "!FileFinal!".mp4)
	if "!qlt!" == "5" (set /P bitrate="BitRate: "
	ffmpeg -i "!FileName!" -vcodec h264_nvenc -b:v "!bitrate!"k -acodec mp3 "!FileFinal!".mp4)
	echo.
	echo.
    echo Conversao realizada, ou nao
    timeout /t 3 /nobreak >NULL
    GOTO 5
)
:2
if not "!FileName!" == "" (
    set "FileFinal=!FileFinal:.mp4=!
    echo.
    echo The file name is: !FileName!
    ffmpeg -i "!FileName!" -vcodec h264_nvenc -acodec mp3 "!FileFinal!".mp3
    cls
    echo Conversao realizada (Ou nao)
    timeout /t 2 /nobreak >NULL
    GOTO 5
)
:3
if not "!FileName!" == "" (
    set "FileFinal=!FileFinal:.mp4=! - Compressed
    echo.
    echo The file name is: !FileName!
    pause
    ffmpeg -i "!FileName!" -c:v libvpx-vp9 "!FileFinal!".mp4
    pause
    cls
    echo Conversao realizada (Ou nao)
    timeout /t 2 /nobreak >NULL
    GOTO 5
)