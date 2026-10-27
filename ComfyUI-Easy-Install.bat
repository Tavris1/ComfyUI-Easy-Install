@echo off&&cd /D "%~dp0"
set "CEI_Title=ComfyUI-Easy-Install by ivo v3.27.0"
Title %CEI_Title%
:: Pixaroma Community Edition ::

set "GIT_TERMINAL_PROMPT=0"
set "GIT_ASKPASS=echo"
set "GCM_INTERACTIVE=never"

:: Set Ignoring Large File Storage ::
set GIT_LFS_SKIP_SMUDGE=1

:: Set arguments ::
set "PIPargs=--no-cache-dir --no-warn-script-location --timeout=1000 --retries 10"
set "UVargs=--no-cache --link-mode=copy"

:: Add a path just in case ::
for /f "delims=" %%G in ('cmd /c "where.exe git.exe 2>nul"') do (set "GIT_PATH=%%~dpG")
set "path=%GIT_PATH%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0;%localappdata%\Microsoft\WindowsApps;%path%"

set "FATAL="
call :SET_COLORS

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "if(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){exit 10}else{exit 0}"
if %errorlevel% equ 10 (
	if /I "%~1"=="CEI_NOADMIN" (
		cls
		echo %warning%WARNING:%reset% This installer cannot run with %yellow%Administrator%reset% rights
		echo %green%Start it with a normal double-click, NOT with %yellow%Run as administrator%reset%
		echo Press any key to Exit...&Pause>nul
		exit /b 1
	)
	echo %warning%WARNING:%reset% Administrator rights detected. Restarting without them...
	if exist "%TEMP%\CEI_deelevate.flag" (
		runas.exe /trustlevel:0x20000 "cmd.exe /c \"\"%~f0\" CEI_NOADMIN\""
		if errorlevel 1 (
			echo.
			echo %red%Failed to restart without Administrator rights%reset%
			echo %green%Start this file with a normal double-click, NOT with %yellow%Run as administrator%reset%
			echo Press any key to Exit...&Pause>nul
			exit /b 1
		)
		exit /b 0
	)
	(echo.>"%TEMP%\CEI_deelevate.flag") 2>nul
	"%SystemRoot%\explorer.exe" "%~f0"
	exit /b 0
)
del "%TEMP%\CEI_deelevate.flag" >nul 2>&1

set "CEI_HOME=%~dp0"
if "%CEI_HOME:~0,2%"=="\\" (
	cls
	echo %warning%WARNING:%reset% Network paths ^(UNC^) are not supported
	echo %green%Copy the entire package to a local drive and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)

call :NVIDIA_DRIVER_CHECK
if defined FATAL exit /b 1

:: Check for Existing ComfyUI Folder ::
if exist "ComfyUI-Easy-Install" (
	echo %warning%WARNING:%reset% '%bold%ComfyUI-Easy-Install%reset%' folder already exists!
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)

:: Check for Existing Helper-CEI ::
set "HLPR_NAME=Helper-CEI.zip"
if not exist "%HLPR_NAME%" (
	echo %warning%WARNING:%reset% '%bold%%HLPR_NAME%%reset%' not exists!
	echo %green%Unzip the entire package and try again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)

call :CHECK_LOCATION
if defined FATAL exit /b 1
call :CHECK_NON_ASCII

:: Capture the start time ::
for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -command "Get-Date -Format yyyy-MM-dd_HH:mm:ss"') do set start=%%i

:: Show Logo ::
set BGR=%yellow%
set FGR=%green%
echo.
echo    %BGR%0000000000000000000000000000
echo    %BGR%000000000000%FGR%0000%BGR%000000000000
echo    %BGR%0000%FGR%0000000%BGR%0%FGR%0000%BGR%0%FGR%0000000%BGR%0000
echo    %BGR%0000%FGR%0000000%BGR%0%FGR%0000%BGR%0%FGR%0000000%BGR%0000
echo    %BGR%0000%FGR%0000%BGR%0000%FGR%0000%BGR%0000%FGR%0000%BGR%0000
echo    %BGR%0000%FGR%0000%BGR%0000%FGR%0000%BGR%0000%FGR%0000%BGR%0000
echo    %BGR%0000%FGR%0000%BGR%000000000000%FGR%0000%BGR%0000
echo    %BGR%0000%FGR%00000000000000000000%BGR%0000
echo    %BGR%0000%FGR%00000000000000000000%BGR%0000
echo    %BGR%0000000000000000000000000000
echo    %BGR%0000000 %FGR%EZi  DESKTOP%BGR% 0000000
echo.

:: Install/Update Git ::
call :install_git

:: Check if git is installed ::
for /F "tokens=*" %%g in ('git --version') do (set gitversion=%%g)
echo %gitversion% | findstr /C:"version">nul&&(
	echo %bold%git%reset% %yellow%is installed%reset%
	echo.) || (
    echo %warning%WARNING:%reset% %bold%'git'%reset% is NOT installed
	echo Please install %bold%'git'%reset% manually from %yellow%https://git-scm.com/%reset% and run this installer again
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)

:: System folder? ::
md "ComfyUI-Easy-Install"
if not exist "ComfyUI-Easy-Install" (
	cls
	echo %warning%WARNING:%reset% Cannot create folder %yellow%ComfyUI-Easy-Install%reset%
	echo Make sure you are NOT using system folders like %yellow%Program Files, Windows%reset% or system root %yellow%C:\%reset%
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)
cd "ComfyUI-Easy-Install"

:: Install ComfyUI ::
call :install_comfyui
if defined FATAL exit /b 1

echo %green%::::::::::::::: %yellow%Pre-installation of required modules%green% :::::::::::::::%reset%
echo.
REM .\python_embeded\python.exe -I -m uv pip install requests==2.31.0 urllib3==2.6.3 charset_normalizer==3.4.4
.\python_embeded\python.exe -I -m uv pip install kornia==0.7.4 %UVargs%
.\python_embeded\python.exe -I -m uv pip install scipy==1.17.1 %UVargs%
.\python_embeded\python.exe -I -m uv pip install chardet==5.2.0 %UVargs%
.\python_embeded\python.exe -I -m uv pip install scikit-build-core %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnxruntime-gpu %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnx %UVargs%
.\python_embeded\python.exe -I -m uv pip install flet %UVargs%
.\python_embeded\python.exe -I -m uv pip install pywebview %UVargs%
.\python_embeded\python.exe -I -m uv pip install pywinpty %UVargs%
.\python_embeded\python.exe -I -m uv pip install -r ".\ComfyUI\manager_requirements.txt" %UVargs%

if "%CURRENT_CUDA%"=="12.8" (
    .\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.4.3-cu128-win-20261017/llama_cpp_python-0.4.3+cu128-cp312-cp312-win_amd64.whl %UVargs%
) else (
    .\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.4.3-cu130-win-20261017/llama_cpp_python-0.4.3+cu130-cp312-cp312-win_amd64.whl %UVargs%

)

:: Install working version of stringzilla (damn it) ::
.\python_embeded\python.exe -I -m uv pip install stringzilla==3.12.6 %UVargs%
:: Install working version of transformers (damn it again)::
.\python_embeded\python.exe -I -m uv pip install transformers==4.57.6 %UVargs%
.\python_embeded\python.exe -I -m uv pip install descript-audio-codec %UVargs%
echo.

:: Install Triton ::
if "%CURRENT_CUDA%"=="12.8" (
	.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.5" %PIPargs%
) else (
	.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.7" %PIPargs%
)
echo.

:: Install Pixaroma's Related Nodes ::
call :get_node https://github.com/Comfy-Org/ComfyUI-Manager					comfyui-manager
call :get_node https://github.com/yolain/ComfyUI-Easy-Use					ComfyUI-Easy-Use
call :get_node https://github.com/Fannovel16/comfyui_controlnet_aux			comfyui_controlnet_aux
call :get_node https://github.com/rgthree/rgthree-comfy						rgthree-comfy
call :get_node https://github.com/MohammadAboulEla/ComfyUI-iTools			comfyui-itools
call :get_node https://github.com/city96/ComfyUI-GGUF						ComfyUI-GGUF
call :get_node https://github.com/gseth/ControlAltAI-Nodes					controlaltai-nodes
call :get_node https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch	comfyui-inpaint-cropandstitch
call :get_node https://github.com/1038lab/ComfyUI-RMBG						comfyui-rmbg
call :get_node https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite		comfyui-videohelpersuite
call :get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion			ComfyUI-TiledDiffusion
call :get_node https://github.com/kijai/ComfyUI-KJNodes						comfyui-kjnodes
call :get_node https://github.com/kijai/ComfyUI-WanVideoWrapper				ComfyUI-WanVideoWrapper
call :get_node https://github.com/1038lab/ComfyUI-QwenVL					ComfyUI-QwenVL
call :get_node https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler		seedvr2_videoupscaler
call :get_node https://github.com/chflame163/ComfyUI_LayerStyle				comfyui_layerstyle
call :get_node https://github.com/kijai/ComfyUI-WanAnimatePreprocess		ComfyUI-WanAnimatePreprocess
call :get_node https://github.com/yolain/ComfyUI-Easy-Sam3					comfyui-easy-sam3
call :get_node https://github.com/kijai/ComfyUI-SCAIL-Pose					ComfyUI-SCAIL-Pose
call :get_node https://github.com/kijai/ComfyUI-MelBandRoFormer				ComfyUI-MelBandRoFormer
call :get_node https://github.com/flybirdxx/ComfyUI-Qwen-TTS				qwen3-tts-comfyui
call :get_node https://gitlab.com/pixaroma/ComfyUI-Pixaroma.git				ComfyUI-Pixaroma
REM call :get_node https://github.com/capitan01R/ComfyUI-Krea2T-Enhancer        ComfyUI-Krea2T-Enhancer
call :get_node https://github.com/lbouaraba/comfyui-krea2edit               comfyui-krea2edit

:: Patching rgthree-comfy ::
if exist ".\ComfyUI\custom_nodes\rgthree-comfy" echo {"patch_recursive_execution": false} > ".\ComfyUI\custom_nodes\rgthree-comfy\rgthree_config.json"

:: Check if SoX is already installed - skip silently if found
where sox.exe >nul 2>&1
if not errorlevel 1 goto SkipSoX

echo.
echo %green%::::::::::::::::::::: %yellow%Installing SoX%green% :::::::::::::::::::::%reset%
echo.

set "SOX_ROOT=%LocalAppData%\SoX"
set "SOX_DIR=%SOX_ROOT%\sox-14.4.2"
set "SOX_ZIP=%TEMP%\sox-14.4.2-win32.zip"

curl.exe -fL --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "%SOX_ZIP%" "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2-win32.zip"
if not exist "%SOX_ZIP%" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Start-BitsTransfer -Source 'https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2-win32.zip' -Destination $env:SOX_ZIP -ErrorAction Stop } catch { exit 1 }"
)

if exist "%SOX_ZIP%" (
    if not exist "%SOX_ROOT%" mkdir "%SOX_ROOT%"
    tar.exe -xmf "%SOX_ZIP%" -C "%SOX_ROOT%"
    del "%SOX_ZIP%"
)

if exist "%SOX_DIR%\sox.exe" (
    set "path=%path%;%SOX_DIR%"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=$env:SOX_DIR; $p=[Environment]::GetEnvironmentVariable('Path','User'); if(-not (($p -split ';') -contains $d)){[Environment]::SetEnvironmentVariable('Path', ([string]$p).TrimEnd(';')+';'+$d, 'User')}"
    echo %green%SoX installed successfully.%reset%
) else (
    echo %warning%WARNING:%reset% Could not install SoX. You can install it manually later from %yellow%https://sourceforge.net/projects/sox/%reset%
)
:SkipSoX
:: Reset errorlevel ::
cd .\
echo.


if not exist ".\ComfyUI\custom_nodes\.disabled" mkdir ".\ComfyUI\custom_nodes\.disabled"

:: Extracting helper folders ::
cd ..\
tar.exe -xmf "%HLPR_NAME%"
if errorlevel 1 powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Microsoft.PowerShell.Archive\Expand-Archive -LiteralPath '%HLPR_NAME%' -DestinationPath '.' -Force"

cd ComfyUI-Easy-Install

if not exist ".\Add-Ons\Tools\Helper-CEI\keep_cache.flag" type nul > ".\Add-Ons\Tools\Helper-CEI\keep_cache.flag"

:: Download media files ::
set "MEDIA_ZIP=Media-CEI.zip"
set "MEDIA_URL=https://github.com/Tavris1/ComfyUI-Easy-Install/releases/download/assets/%MEDIA_ZIP%"
set "MEDIA_OK="
curl.exe -fL --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "%MEDIA_ZIP%" "%MEDIA_URL%" && set "MEDIA_OK=1"
if defined MEDIA_OK (
	if not exist ".\ComfyUI\input" mkdir ".\ComfyUI\input"
	tar.exe -xmf "%MEDIA_ZIP%" -C ".\ComfyUI\input" || echo %warning%WARNING:%reset% Could not extract %MEDIA_ZIP%
) else (
	echo %warning%WARNING:%reset% Media files were not downloaded.
)
if exist "%MEDIA_ZIP%" del "%MEDIA_ZIP%"
echo.
:: Postinstall
.\python_embeded\python.exe -I -m uv pip uninstall pydantic pydantic-core
.\python_embeded\python.exe -I -m uv pip install pydantic %UVargs%
echo.

:: Install working version of av!!! ::
.\python_embeded\python.exe -I -m uv pip uninstall av --quiet
.\python_embeded\python.exe -I -m uv pip install av==18.0.0 %UVargs%
echo.

if exist ".\Add-Ons\Tools\AutoRun.bat" (
	pushd "%cd%"
	call ".\Add-Ons\Tools\AutoRun.bat" nopause
	popd
	Title %CEI_Title%
	del  ".\Add-Ons\Tools\AutoRun.bat"
)

:: Installing Nunchaku from the Add-ons ::
REM pushd %CD%&&echo.&&call Add-Ons\Nunchaku.bat NoPause&&popd
:: Installing SageAttention from the Add-ons ::
REM pushd %CD%&&echo.&&call Add-Ons\SageAttention.bat NoPause&&popd
:: Installing Insightface from the Add-ons ::
REM pushd %CD%&&echo.&&call Add-Ons\Insightface.bat NoPause&&popd

:: Capture the end time ::
for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -command "Get-Date -Format yyyy-MM-dd_HH:mm:ss"') do set end=%%i
for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -command "$s=[datetime]::ParseExact('%start%','yyyy-MM-dd_HH:mm:ss',$null); $e=[datetime]::ParseExact('%end%','yyyy-MM-dd_HH:mm:ss',$null); if($e -lt $s){$e=$e.AddDays(1)}; ($e-$s).TotalSeconds"') do set diff=%%i

:: Final Messages ::
echo %green%::::::::::::::::: Installation Complete ::::::::::::::::%reset%
echo %green%::::::::::::::::: Total Running Time:%red% %diff% %green%seconds%reset%
echo %yellow%::::::::::::::::: Press any key to exit ::::::::::::::::%reset%&Pause>nul

exit /b 0

::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::

:SET_COLORS
set warning=[33m
set    gray=[90m
set     red=[91m
set   green=[92m
set  yellow=[93m
set    blue=[94m
set magenta=[95m
set    cyan=[96m
set   white=[97m
set   reset=[0m
GOTO :EOF

:CHECK_LOCATION
set "CEI_ROOT=%CD%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$r=[IO.Path]::GetFullPath($env:CEI_ROOT).TrimEnd('\')+'\'; if($r -ieq ($env:SystemDrive+'\')){exit 1}; foreach($d in @($env:SystemRoot,$env:ProgramFiles,${env:ProgramFiles(x86)},$env:ProgramW6432)){if($d -and $r.StartsWith($d.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){exit 1}}; exit 0"
if errorlevel 1 (
	cls
	echo %warning%WARNING:%reset% Cannot install into system folders like %yellow%Program Files, Windows%reset% or system root %yellow%C:\%reset%
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

set "CEI_TEST=.cei_test_%RANDOM%%RANDOM%"
(md "%CEI_TEST%") 2>nul
(echo test>"%CEI_TEST%\write.tmp") 2>nul
if not exist "%CEI_TEST%\write.tmp" (
	rd /s /q "%CEI_TEST%" 2>nul
	cls
	echo %warning%WARNING:%reset% No permission to create folders/files here
	echo Move this file to a folder you own, for example in your user folder or on another drive
	echo %green%Then run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)
rd /s /q "%CEI_TEST%" 2>nul
goto :eof

:CHECK_NON_ASCII
set "CEI_ROOT=%CD%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$c=0; if($env:CEI_ROOT -cmatch '[^\x00-\x7F]'){$c+=1}; if($env:USERPROFILE -cmatch '[^\x00-\x7F]'){$c+=2}; exit $c"
set "CEI_NA=%errorlevel%"
if %CEI_NA% equ 0 goto :eof
echo.
if %CEI_NA% equ 1 echo %red%WARNING: The installation path contains non-English characters. Installation problems are possible.%reset%
if %CEI_NA% equ 3 echo %red%WARNING: The installation path contains non-English characters. Installation problems are possible.%reset%
if %CEI_NA% equ 2 echo %red%WARNING: Your Windows user folder name contains non-English characters. Installation problems are possible.%reset%
if %CEI_NA% equ 3 echo %red%WARNING: Your Windows user folder name contains non-English characters. Installation problems are possible.%reset%
echo %red%Recommended: use a short English-only path, for example D:\AI\%reset%
echo.
timeout /t 3 /nobreak >nul
goto :eof

:install_git
:: https://git-scm.com/
echo %green%::::::::::::::: Installing/Updating%yellow% Git %green%:::::::::::::::%reset%
echo.

:: Winget Install: ms-windows-store://pdp/?productid=9NBLGGH4NNS1 ::
winget.exe install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements
set "path=%PATH%;%ProgramFiles%\Git\cmd"
echo.
goto :eof

:install_comfyui
:: https://github.com/comfyanonymous/ComfyUI
echo %green%::::::::::::::: Installing%yellow% ComfyUI %green%:::::::::::::::%reset%
echo.

git.exe clone https://github.com/Comfy-Org/ComfyUI ComfyUI
if not exist "ComfyUI\requirements.txt" (
	echo.
	echo %red%Failed to clone ComfyUI%reset%
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

md python_embeded&&cd python_embeded

curl.exe -fL --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "python-3.12.10-embed-amd64.zip" "https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip"
if errorlevel 1 powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip' -Destination 'python-3.12.10-embed-amd64.zip' -ErrorAction Stop}catch{exit 1}"
if not exist "python-3.12.10-embed-amd64.zip" (
echo.
echo %red%Failed to download python-3.12.10-embed-amd64.zip%reset%
echo Check your date and time, Windows updates and antivirus HTTPS scanning
echo Press any key to Exit...&Pause>nul
set "FATAL=1"
goto :eof
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try{if((Get-FileHash -LiteralPath 'python-3.12.10-embed-amd64.zip' -Algorithm SHA256).Hash -eq '4acbed6dd1c744b0376e3b1cf57ce906f9dc9e95e68824584c8099a63025a3c3'){exit 0}else{exit 1}}catch{exit 1}"
if errorlevel 1 (
	erase "python-3.12.10-embed-amd64.zip"
	echo.
	echo %red%Python archive checksum does not match%reset%
	echo The download may be corrupted or modified. Delete the %yellow%ComfyUI-Easy-Install%reset% folder and run this installer again
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

tar.exe -xmf python-3.12.10-embed-amd64.zip
if errorlevel 1 powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath 'python-3.12.10-embed-amd64.zip' -DestinationPath '.' -Force"
erase python-3.12.10-embed-amd64.zip

if not exist "python.exe" (
	echo.
	echo %red%Failed to extract python.exe%reset%
	echo Your antivirus may have blocked Python files. Check %yellow%Windows Security, Protection history%reset%
	echo Delete the %yellow%ComfyUI-Easy-Install%reset% folder, allow it in your antivirus and run this installer again
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

curl.exe -fL --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "get-pip.py" "https://bootstrap.pypa.io/get-pip.py"
if errorlevel 1 powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://bootstrap.pypa.io/get-pip.py' -Destination 'get-pip.py' -ErrorAction Stop}catch{exit 1}"

if not exist "get-pip.py" curl.exe -fL --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "get-pip.py" "https://raw.githubusercontent.com/pypa/get-pip/main/public/get-pip.py"
if not exist "get-pip.py" powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://raw.githubusercontent.com/pypa/get-pip/main/public/get-pip.py' -Destination 'get-pip.py' -ErrorAction Stop}catch{exit 1}"

if not exist "get-pip.py" (
echo.
echo %red%Failed to download get-pip.py%reset%
echo Check your date and time, Windows updates and antivirus HTTPS scanning
echo Press any key to Exit...&Pause>nul
set "FATAL=1"
goto :eof
)

echo ../ComfyUI> python312._pth
echo python312.zip>> python312._pth
echo .>> python312._pth
echo Lib/site-packages>> python312._pth
echo Lib>> python312._pth
echo Scripts>> python312._pth
echo import site>> python312._pth

echo [global]> pip.ini
echo trusted-host =>> pip.ini
echo     pypi.org>> pip.ini
echo     files.pythonhosted.org>> pip.ini
echo     pypi.python.org>> pip.ini

.\python.exe -I get-pip.py %PIPargs% --trusted-host pypi.org --trusted-host files.pythonhosted.org --trusted-host pypi.python.org
.\python.exe -I -m pip --version >nul 2>&1
if errorlevel 1 (
	echo.
	echo %red%Failed to install pip%reset%
	echo Your antivirus may have blocked Python files. Check %yellow%Windows Security, Protection history%reset%
	echo Delete the %yellow%ComfyUI-Easy-Install%reset% folder, allow it in your antivirus and run this installer again
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)
REM .\python.exe -I -m pip config set global.trusted-host "pypi.org files.pythonhosted.org pypi.python.org"

REM .\python.exe -I -m pip install uv==0.9.7 %PIPargs%
.\python.exe -I -m pip install uv %PIPargs%
.\python.exe -I -m uv --version >nul 2>&1
if errorlevel 1 (
	echo.
	echo %red%Failed to install uv%reset%
	echo Your antivirus may have blocked Python files. Check %yellow%Windows Security, Protection history%reset%
	echo Delete the %yellow%ComfyUI-Easy-Install%reset% folder, allow it in your antivirus and run this installer again
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

if "%CURRENT_CUDA%"=="12.8" (
	.\python.exe -I -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/cu128 %PIPargs%
) else (
	.\python.exe -I -m pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu130 %PIPargs%
)

.\python.exe -I -m uv pip install pygit2 %UVargs%
cd ..\ComfyUI

..\python_embeded\python.exe -I -m uv pip install -r requirements.txt %UVargs%
cd ..\
echo.
goto :eof

:get_node
set "git_url=%~1"
set "git_folder=%~2"

git.exe -c credential.interactive=never ls-remote --exit-code "%git_url%" HEAD >nul 2>&1
if errorlevel 1 (
    echo %yellow%[SKIPPED]%reset% %git_folder% - repository not reachable, skipping.
    echo.
    goto :eof
)

echo %green%::::::::::::::: Installing%yellow% %git_folder% %green%:::::::::::::::%reset%
echo.

git.exe -c credential.interactive=never clone "%git_url%" "ComfyUI/custom_nodes/%git_folder%"
if errorlevel 1 (
    echo %yellow%[SKIPPED]%reset% %git_folder% could not be downloaded, skipping.
    echo.
    goto :eof
)

setlocal enabledelayedexpansion
if exist ".\ComfyUI\custom_nodes\%git_folder%\requirements.txt" (
    for %%F in (".\ComfyUI\custom_nodes\%git_folder%\requirements.txt") do set filesize=%%~zF
    if not !filesize! equ 0 (
        .\python_embeded\python.exe -I -m uv pip install -r ".\ComfyUI\custom_nodes\%git_folder%\requirements.txt" %UVargs%
    )
)

if exist ".\ComfyUI\custom_nodes\%git_folder%\install.py" (
    for %%F in (".\ComfyUI\custom_nodes\%git_folder%\install.py") do set filesize=%%~zF
    if not !filesize! equ 0 (
	.\python_embeded\python.exe -I ".\ComfyUI\custom_nodes\%git_folder%\install.py"
	)
)
endlocal

echo.
goto :eof

:NVIDIA_DRIVER_CHECK
set "NV_MIN=580"
set "CURRENT_CUDA=13.0"
set "NV_FULL="
set "NV_MAJOR="

:: Older drivers install nvidia-smi here ::
if exist "%ProgramFiles%\NVIDIA Corporation\NVSMI\nvidia-smi.exe" set "path=%path%;%ProgramFiles%\NVIDIA Corporation\NVSMI"

where.exe nvidia-smi.exe >nul 2>&1
if errorlevel 1 (
    echo.
    echo %warning%WARNING:%reset% %red%NVIDIA driver not detected%reset%
    echo This installer requires an %yellow%NVIDIA GPU%reset% with an installed driver
    echo Install the latest driver from %yellow%https://www.nvidia.com/drivers%reset% and run this installer again
    echo Press any key to Exit...&Pause>nul
    set "FATAL=1"
    goto :eof
)

for /f %%a in ('nvidia-smi --query-gpu^=driver_version --format^=csv^,noheader 2^>nul') do set "NV_FULL=%%a"
for /f "tokens=1 delims=." %%a in ("%NV_FULL%") do set "NV_MAJOR=%%a"

echo %NV_MAJOR%| findstr /R "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo.
    echo %warning%WARNING:%reset% %red%Unable to read NVIDIA driver version%reset%
    echo Make sure the NVIDIA driver is working ^(run %yellow%nvidia-smi%reset% in a terminal to check^)
    echo Press any key to Exit...&Pause>nul
    set "FATAL=1"
    goto :eof
)

if %NV_MAJOR% LSS %NV_MIN% (
	echo.
    echo %red%   Your NVIDIA driver %yellow%^(%NV_FULL%^)%red% is below %yellow%%NV_MIN%%reset%
	echo %warning%   Drivers below %yellow%%NV_MIN%%warning% do not support %yellow%CUDA 13%warning% or newer%reset%
    echo %warning%   Recommendation: Update NVIDIA drivers%reset%
	echo.
	echo %green%   The installation will continue with CUDA 12.8.%reset%
	set "CURRENT_CUDA=12.8"
)

GOTO :EOF