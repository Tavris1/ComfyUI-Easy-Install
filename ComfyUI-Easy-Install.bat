@echo off&&cd /D "%~dp0"
set "CEI_Title=ComfyUI-Easy-Install by ivo v3.30.0"
Title %CEI_Title%
:: Pixaroma Community Edition ::

set "CEI_BAT=%~f0"
set "CEI_GUI=%~dp0Helper-CEI.ps1"
set "CEI_STAGES=Preparing|Python packages|Custom nodes|Finishing"
set "CEI_NODE_STAGE=3"
set "CEI_WORKER="
if /I "%~1"=="CEI_WORKER" set "CEI_WORKER=1"

set "GIT_TERMINAL_PROMPT=0"
set "GIT_ASKPASS=echo"
set "GCM_INTERACTIVE=never"

:: Set Ignoring Large File Storage ::
set GIT_LFS_SKIP_SMUDGE=1

:: Set arguments ::
set "PIPargs=--no-cache-dir --no-warn-script-location --timeout=1000 --retries 10"
if defined CEI_WORKER set "PIPargs=%PIPargs% --progress-bar raw"
set "CURLprogress=--progress-bar"
if defined CEI_WORKER set "CURLprogress=-sS"
set "UVargs=--no-cache --link-mode=copy"

:: Add a path just in case ::
for /f "delims=" %%G in ('cmd /c "where.exe git.exe 2>nul"') do (set "GIT_PATH=%%~dpG")
set "path=%GIT_PATH%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0;%localappdata%\Microsoft\WindowsApps;%path%"
set "PSModulePath="
call :FIND_NVSMI

set "FATAL="
call :SET_COLORS

fltmc >nul 2>&1
if not errorlevel 1 (
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

if defined CEI_WORKER goto :gui_done
if /I "%~1"=="CEI_CONSOLE" goto :gui_done
if not exist "%CEI_GUI%" goto :gui_done
call :START_GUI
if defined CEI_GUI_OK exit /b 0
set "CEI_GUI_FAILED=1"
start "" cmd.exe /d /c ""%CEI_BAT%" CEI_CONSOLE"
exit /b 0
:gui_done
if defined CEI_GUI_FAILED (
	echo %warning%WARNING:%reset% The installer window could not start. Continuing in the console...
	echo.
)

call :NVIDIA_DRIVER_CHECK
if defined FATAL exit /b 1

:: Check for Existing ComfyUI Folder ::
if exist "ComfyUI-Easy-Install" (
	echo %warning%WARNING:%reset% '%bold%ComfyUI-Easy-Install%reset%' folder already exists!
	echo %green%Move this file to another folder and run it again.%reset%
	call :fatal "The ComfyUI-Easy-Install folder already exists" "Move the installer files to another folder, or remove the old folder, and run the installer again."
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)

:: Check for Existing Helper-CEI ::
set "HLPR_NAME=Helper-CEI.zip"
if not exist "%HLPR_NAME%" (
	echo %warning%WARNING:%reset% '%bold%%HLPR_NAME%%reset%' not exists!
	echo %green%Unzip the entire package and try again.%reset%
	call :fatal "Helper-CEI.zip is missing" "Unzip the entire package into one folder and run the installer again."
	echo Press any key to Exit...&Pause>nul
	exit /b 1
)

call :CHECK_LOCATION
if defined FATAL exit /b 1
call :CHECK_NON_ASCII

:: Capture the start time ::
for /f "delims=" %%i in ('powershell -NoProfile -ExecutionPolicy Bypass -command "Get-Date -Format yyyy-MM-dd_HH:mm:ss"') do set start=%%i

:: Show Logo ::
if defined CEI_WORKER goto :skip_logo
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

:skip_logo
:: Install/Update Git ::
call :step 1 "Git"
call :install_git

:: Check if git is installed ::
for /F "tokens=*" %%g in ('git --version') do (set gitversion=%%g)
echo %gitversion% | findstr /C:"version">nul&&(
	echo %bold%git%reset% %yellow%is installed%reset%
	echo.) || (
    echo %warning%WARNING:%reset% %bold%'git'%reset% is NOT installed
	echo Please install %bold%'git'%reset% manually from %yellow%https://git-scm.com/%reset% and run this installer again
	call :fatal "Git is not installed" "Install Git from git-scm.com and run the installer again."
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
	call :fatal "Cannot create the ComfyUI-Easy-Install folder here" "Do not use system folders like Program Files, Windows or the root of C:. Move the installer files to a folder like D:\AI and run it again."
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
call :step 2 "kornia"
.\python_embeded\python.exe -I -m uv pip install kornia==0.7.4 %UVargs%
if errorlevel 1 call :err
call :step 2 "scipy"
.\python_embeded\python.exe -I -m uv pip install scipy==1.17.1 %UVargs%
if errorlevel 1 call :err
call :step 2 "chardet"
.\python_embeded\python.exe -I -m uv pip install chardet==5.2.0 %UVargs%
if errorlevel 1 call :err
call :step 2 "scikit-build-core"
.\python_embeded\python.exe -I -m uv pip install scikit-build-core %UVargs%
if errorlevel 1 call :err
call :step 2 "onnxruntime-gpu"
.\python_embeded\python.exe -I -m uv pip install onnxruntime-gpu %UVargs%
if errorlevel 1 call :err
call :step 2 "onnx"
.\python_embeded\python.exe -I -m uv pip install onnx %UVargs%
if errorlevel 1 call :err
call :step 2 "flet"
.\python_embeded\python.exe -I -m uv pip install flet %UVargs%
if errorlevel 1 call :err
call :step 2 "pywebview"
.\python_embeded\python.exe -I -m uv pip install pywebview %UVargs%
if errorlevel 1 call :err
call :step 2 "pywinpty"
.\python_embeded\python.exe -I -m uv pip install pywinpty %UVargs%
if errorlevel 1 call :err
call :step 2 "ComfyUI-Manager requirements"
.\python_embeded\python.exe -I -m uv pip install -r ".\ComfyUI\manager_requirements.txt" %UVargs%
if errorlevel 1 call :err

call :step 2 "llama-cpp-python"
if "%CURRENT_CUDA%"=="12.8" (
    .\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.4.5-cu128-win-20261025/llama_cpp_python-0.4.5+cu128-cp312-cp312-win_amd64.whl %UVargs%
) else (
    .\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.4.5-cu130-win-20261025/llama_cpp_python-0.4.5+cu130-cp312-cp312-win_amd64.whl %UVargs%

)
if errorlevel 1 call :err

call :step 2 "descript-audio-codec"
.\python_embeded\python.exe -I -m uv pip install descript-audio-codec %UVargs%
if errorlevel 1 call :err
echo.

:: Install Triton ::
call :step 2 "Triton"
if "%CURRENT_CUDA%"=="12.8" (
	.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.5" %PIPargs%
) else (
	.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.7" %PIPargs%
)
if errorlevel 1 call :err
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
call :step 4 "SoX"
where sox.exe >nul 2>&1
if not errorlevel 1 goto SkipSoX

echo.
echo %green%::::::::::::::::::::: %yellow%Installing SoX%green% :::::::::::::::::::::%reset%
echo.

set "SOX_ROOT=%LocalAppData%\SoX"
set "SOX_DIR=%SOX_ROOT%\sox-14.4.2"
set "SOX_ZIP=%TEMP%\sox-14.4.2-win32.zip"

curl.exe -fL %CURLprogress% --ssl-no-revoke --retry 5 --retry-delay 2 -o "%SOX_ZIP%" "https://downloads.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2-win32.zip"
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
    call :warn "SoX could not be installed - it can be installed manually later"
)
:SkipSoX
:: Reset errorlevel ::
cd .\
echo.


if not exist ".\ComfyUI\custom_nodes\.disabled" mkdir ".\ComfyUI\custom_nodes\.disabled"

:: Extracting helper folders ::
call :step 4 "Helper files"
cd ..\
tar.exe -xmf "%HLPR_NAME%"
if errorlevel 1 powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Microsoft.PowerShell.Archive\Expand-Archive -LiteralPath '%HLPR_NAME%' -DestinationPath '.' -Force"

cd ComfyUI-Easy-Install
if not exist ".\Add-Ons\Tools\Helper-CEI" call :err

if not exist ".\Add-Ons\Tools\Helper-CEI\keep_cache.flag" type nul > ".\Add-Ons\Tools\Helper-CEI\keep_cache.flag"

:: Download media files ::
call :step 4 "Example media"
set "MEDIA_ZIP=Media-CEI.zip"
set "MEDIA_URL=https://github.com/Tavris1/ComfyUI-Easy-Install/releases/download/assets/%MEDIA_ZIP%"
set "MEDIA_OK="
curl.exe -fL %CURLprogress% --ssl-no-revoke --retry 5 --retry-delay 2 -o "%MEDIA_ZIP%" "%MEDIA_URL%" && set "MEDIA_OK=1"
if defined MEDIA_OK (
	if not exist ".\ComfyUI\input" mkdir ".\ComfyUI\input"
	tar.exe -xmf "%MEDIA_ZIP%" -C ".\ComfyUI\input" || echo %warning%WARNING:%reset% Could not extract %MEDIA_ZIP%
) else (
	echo %warning%WARNING:%reset% Media files were not downloaded.
	call :warn "Example media files were not downloaded"
)
if exist "%MEDIA_ZIP%" del "%MEDIA_ZIP%"
echo.
:: Postinstall
call :step 4 "pydantic"
.\python_embeded\python.exe -I -m uv pip uninstall pydantic pydantic-core
.\python_embeded\python.exe -I -m uv pip install pydantic %UVargs%
if errorlevel 1 call :err
echo.

:: Install working version of av!!! ::
call :step 4 "PyAV"
.\python_embeded\python.exe -I -m uv pip uninstall av --quiet
.\python_embeded\python.exe -I -m uv pip install av==18.0.0 %UVargs%
if errorlevel 1 call :err
echo.

call :step 4 "Final setup"
if exist ".\Add-Ons\Tools\AutoRun.bat" (
	pushd "%cd%"
	if defined CEI_WORKER (
		cmd.exe /d /c call ".\Add-Ons\Tools\AutoRun.bat" nopause
	) else (
		call ".\Add-Ons\Tools\AutoRun.bat" nopause
	)
	popd
	Title %CEI_Title%
	if not defined CEI_WORKER del ".\Add-Ons\Tools\AutoRun.bat"
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
if defined CEI_WORKER echo ##DONE^|%diff%
echo %yellow%::::::::::::::::: Press any key to exit ::::::::::::::::%reset%&Pause>nul

exit /b 0

::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::

:SET_COLORS
if defined CEI_WORKER goto :SET_NO_COLORS
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
:SET_NO_COLORS
for %%v in (warning gray red green yellow blue magenta cyan white reset bold) do set "%%v="
GOTO :EOF

:START_GUI
set "CEI_GUI_OK="
set "CEI_GUI_FLAG=%TEMP%\CEI_gui_%RANDOM%%RANDOM%.flag"
del "%CEI_GUI_FLAG%" "%CEI_GUI_FLAG%.cancel" "%CEI_GUI_FLAG%.fail" >nul 2>&1
echo %green%Starting the installer window...%reset%
start "" /b powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%CEI_GUI%" -BatPath "%CEI_BAT%" -Flag "%CEI_GUI_FLAG%"
for /l %%i in (1,1,10) do (
	if exist "%CEI_GUI_FLAG%" goto :START_GUI_OK
	if exist "%CEI_GUI_FLAG%.fail" goto :START_GUI_FAIL
	timeout /t 1 /nobreak >nul
)
type nul > "%CEI_GUI_FLAG%.cancel"
timeout /t 2 /nobreak >nul
if exist "%CEI_GUI_FLAG%" goto :START_GUI_OK
:START_GUI_FAIL
del "%CEI_GUI_FLAG%.fail" >nul 2>&1
echo %warning%WARNING:%reset% The installer window could not start. Continuing in this console...
echo.
goto :eof
:START_GUI_OK
del "%CEI_GUI_FLAG%" >nul 2>&1
set "CEI_GUI_OK=1"
goto :eof

:step
set "CEI_LABEL=%~2"
if not defined CEI_WORKER goto :eof
echo ##STEP^|%~1^|%~2
goto :eof

:err
if defined CEI_WORKER goto :err_worker
echo %red%[ERROR]%reset% %CEI_LABEL% failed
goto :eof
:err_worker
echo ##ERR^|%CEI_LABEL%
goto :eof

:warn
if not defined CEI_WORKER goto :eof
echo ##WARN^|%~1
goto :eof
:FIND_NVSMI
set "NV_SMI="
for %%P in ("%windir%\System32\nvidia-smi.exe" "%windir%\Sysnative\nvidia-smi.exe" "%ProgramFiles%\NVIDIA Corporation\NVSMI\nvidia-smi.exe") do if not defined NV_SMI if exist "%%~P" set "NV_SMI=%%~P"
if not defined NV_SMI for /f "delims=" %%P in ('where.exe nvidia-smi.exe 2^>nul') do if not defined NV_SMI set "NV_SMI=%%P"
if not defined NV_SMI for %%R in ("%windir%\System32" "%windir%\Sysnative") do for /d %%D in ("%%~R\DriverStore\FileRepository\nv*") do if not defined NV_SMI if exist "%%~D\nvidia-smi.exe" set "NV_SMI=%%~D\nvidia-smi.exe"
if defined NV_SMI for %%D in ("%NV_SMI%") do set "path=%%~dpD;%path%"
goto :eof

:fatal
if not defined CEI_WORKER goto :eof
echo ##FATAL^|%~1^|%~2
goto :eof

:info
if not defined CEI_WORKER goto :eof
echo ##INFO^|%~1
goto :eof

:CHECK_LOCATION
set "CEI_ROOT=%CD%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$r=[IO.Path]::GetFullPath($env:CEI_ROOT).TrimEnd('\')+'\'; if($r -ieq ($env:SystemDrive+'\')){exit 1}; foreach($d in @($env:SystemRoot,$env:ProgramFiles,${env:ProgramFiles(x86)},$env:ProgramW6432)){if($d -and $r.StartsWith($d.TrimEnd('\')+'\',[StringComparison]::OrdinalIgnoreCase)){exit 1}}; exit 0"
if errorlevel 1 (
	cls
	echo %warning%WARNING:%reset% Cannot install into system folders like %yellow%Program Files, Windows%reset% or system root %yellow%C:\%reset%
	echo %green%Move this file to another folder and run it again.%reset%
	call :fatal "Cannot install into a system folder" "Move the installer files to a folder like D:\AI and run the installer again."
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
	call :fatal "No permission to create files in this folder" "Move the installer files to a folder you own, for example D:\AI, and run the installer again."
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
call :warn "The path or user folder contains non-English characters - problems are possible"
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

call :step 1 "ComfyUI"
git.exe clone https://github.com/Comfy-Org/ComfyUI ComfyUI
if not exist "ComfyUI\requirements.txt" (
	echo.
	echo %red%Failed to clone ComfyUI%reset%
	call :fatal "Could not download ComfyUI" "Check your internet connection and that github.com opens in your browser. Then delete the ComfyUI-Easy-Install folder and run the installer again."
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

call :step 1 "Python 3.12"
md python_embeded&&cd python_embeded

curl.exe -fL %CURLprogress% --ssl-no-revoke --retry 5 --retry-delay 2 -o "python-3.12.10-embed-amd64.zip" "https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip"
if errorlevel 1 powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip' -Destination 'python-3.12.10-embed-amd64.zip' -ErrorAction Stop}catch{exit 1}"
if not exist "python-3.12.10-embed-amd64.zip" (
echo.
echo %red%Failed to download python-3.12.10-embed-amd64.zip%reset%
echo Check your date and time, Windows updates and antivirus HTTPS scanning
call :fatal "Could not download Python" "Check your internet connection, the date and time of your PC and antivirus HTTPS scanning. Then delete the ComfyUI-Easy-Install folder and run the installer again."
echo Press any key to Exit...&Pause>nul
set "FATAL=1"
goto :eof
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try{$h=(Get-FileHash -LiteralPath 'python-3.12.10-embed-amd64.zip' -Algorithm SHA256 -ErrorAction Stop).Hash}catch{Write-Host $_.Exception.Message;exit 2};if($h -eq '4acbed6dd1c744b0376e3b1cf57ce906f9dc9e95e68824584c8099a63025a3c3'){exit 0}else{Write-Host ('Actual SHA256: '+$h);exit 1}"
set "HASH_RC=%errorlevel%"
if %HASH_RC% equ 2 (
	echo.
	echo %red%Could not calculate the checksum of python-3.12.10-embed-amd64.zip%reset%
	echo The download itself may be fine. Check your PowerShell and antivirus settings
	echo Delete the %yellow%ComfyUI-Easy-Install%reset% folder and run this installer again from a normal CMD window
	call :fatal "Could not verify the Python download" "Check your PowerShell and antivirus settings. Then delete the ComfyUI-Easy-Install folder and run the installer again."
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)
if %HASH_RC% neq 0 (
	erase "python-3.12.10-embed-amd64.zip"
	echo.
	echo %red%Python archive checksum does not match%reset%
	echo The download may be corrupted or modified. Delete the %yellow%ComfyUI-Easy-Install%reset% folder and run this installer again
	call :fatal "The Python download is damaged" "The file was corrupted or modified during download. Then delete the ComfyUI-Easy-Install folder and run the installer again."
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
	call :fatal "Python files could not be extracted" "Your antivirus may have blocked them - check Windows Security, Protection history. Then delete the ComfyUI-Easy-Install folder and run the installer again."
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

call :step 1 "pip"
set "CEI_PIP_DOWNLOAD_OK="
curl.exe -fL %CURLprogress% --ssl-no-revoke --retry 5 --retry-delay 2 -o "get-pip.py" "https://bootstrap.pypa.io/get-pip.py"
if not errorlevel 1 set "CEI_PIP_DOWNLOAD_OK=1"
if defined CEI_PIP_DOWNLOAD_OK goto :cei_get_pip_downloaded

powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://bootstrap.pypa.io/get-pip.py' -Destination 'get-pip.py' -ErrorAction Stop;exit 0}catch{exit 1}"
if not errorlevel 1 set "CEI_PIP_DOWNLOAD_OK=1"
if defined CEI_PIP_DOWNLOAD_OK goto :cei_get_pip_downloaded

curl.exe -fL %CURLprogress% --ssl-no-revoke --retry 5 --retry-delay 2 -o "get-pip.py" "https://raw.githubusercontent.com/pypa/get-pip/main/public/get-pip.py"
if not errorlevel 1 set "CEI_PIP_DOWNLOAD_OK=1"
if defined CEI_PIP_DOWNLOAD_OK goto :cei_get_pip_downloaded

powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://raw.githubusercontent.com/pypa/get-pip/main/public/get-pip.py' -Destination 'get-pip.py' -ErrorAction Stop;exit 0}catch{exit 1}"
if not errorlevel 1 set "CEI_PIP_DOWNLOAD_OK=1"

:cei_get_pip_downloaded
if not exist "get-pip.py" set "CEI_PIP_DOWNLOAD_OK="
if not defined CEI_PIP_DOWNLOAD_OK (
    echo.
    echo %red%Failed to download get-pip.py%reset%
    echo Check the download errors above, your internet connection and system date and time.
    call :fatal "Could not download pip" "Check your internet connection and the date and time of your PC. Then delete the ComfyUI-Easy-Install folder and run the installer again."
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

:: Extract bundled pip directly without running get-pip.py ::
echo Installing pip from the bundled copy...
.\python.exe -I -c "import base64,io,zipfile;src=open('get-pip.py','rb').read().decode('utf-8');assert 'DATA = b'+chr(34)*3 in src, 'Bundled pip DATA marker not found';blob=src.partition('DATA = b'+chr(34)*3)[2].rsplit(chr(34)*3,1)[0];assert blob.strip(), 'Bundled pip DATA is empty';z=zipfile.ZipFile(io.BytesIO(base64.b85decode(b''.join(blob.encode().split()))));assert 'pip/__main__.py' in z.namelist(), 'Bundled archive does not contain pip';assert z.testzip() is None, 'Bundled pip archive is corrupt';z.extractall('Lib/site-packages')"
if errorlevel 1 (
    echo.
    echo %red%Failed to unpack the bundled pip%reset%
    echo Check the extraction error above. The get-pip.py file may be incomplete or its format may have changed.
    call :fatal "Could not unpack pip" "The downloaded get-pip.py may be incomplete. Then delete the ComfyUI-Easy-Install folder and run the installer again."
    echo Press any key to Exit...&Pause>nul
    set "FATAL=1"
    goto :eof
)
.\python.exe -I -m pip --version >nul 2>&1
if errorlevel 1 (
	echo.
	echo %red%Failed to install pip%reset%
	echo Check the messages above and your internet connection. If your antivirus blocked Python files, see %yellow%Windows Security, Protection history%reset%
	echo Delete the %yellow%ComfyUI-Easy-Install%reset% folder and run this installer again
	call :fatal "Could not install pip" "Check your internet connection. Your antivirus may have blocked Python files - check Windows Security, Protection history. Then delete the ComfyUI-Easy-Install folder and run the installer again."
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)
.\python.exe -I -m pip install --upgrade %PIPargs% pip
if errorlevel 1 (
    echo.
    echo %red%Failed to complete pip installation%reset%
    echo Check the messages above and your internet connection.
    call :fatal "Could not update pip" "Check your internet connection. Then delete the ComfyUI-Easy-Install folder and run the installer again."
    echo Press any key to Exit...&Pause>nul
    set "FATAL=1"
    goto :eof
)

.\python.exe -I -m pip --version
if errorlevel 1 (
    echo.
    echo %red%Pip verification failed after the upgrade%reset%
    echo Check the Python error above. Installation has been stopped.
    call :fatal "pip does not work after the update" "Use Copy details and ask for help."
    echo Press any key to Exit...&Pause>nul
    set "FATAL=1"
    goto :eof
)
echo %green%Pip is ready.%reset%

:cei_pip_ready
call :step 1 "uv"
.\python.exe -I -m pip install uv %PIPargs%
.\python.exe -I -m uv --version >nul 2>&1
if errorlevel 1 (
	echo.
	echo %red%Failed to install uv%reset%
	echo Your antivirus may have blocked Python files. Check %yellow%Windows Security, Protection history%reset%
	echo Delete the %yellow%ComfyUI-Easy-Install%reset% folder, allow it in your antivirus and run this installer again
	call :fatal "Could not install uv" "Your antivirus may have blocked Python files - check Windows Security, Protection history. Then delete the ComfyUI-Easy-Install folder and run the installer again."
	echo Press any key to Exit...&Pause>nul
	set "FATAL=1"
	goto :eof
)

call :step 1 "PyTorch"
if "%CURRENT_CUDA%"=="12.8" (
	.\python.exe -I -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/cu128 %PIPargs%
) else (
	.\python.exe -I -m pip install torch==2.11.0 torchvision==0.26.0 torchaudio==2.11.0 --index-url https://download.pytorch.org/whl/cu130 %PIPargs%
)
if errorlevel 1 call :err

call :step 1 "ComfyUI requirements"
.\python.exe -I -m uv pip install pygit2 %UVargs%
if errorlevel 1 call :err
cd ..\ComfyUI

..\python_embeded\python.exe -I -m uv pip install -r requirements.txt %UVargs%
if errorlevel 1 call :err
cd ..\
echo.
goto :eof

:get_node
set "git_url=%~1"
set "git_folder=%~2"
call :step %CEI_NODE_STAGE% "%git_folder%"

git.exe -c credential.interactive=never ls-remote --exit-code "%git_url%" HEAD >nul 2>&1
if errorlevel 1 (
    echo %yellow%[SKIPPED]%reset% %git_folder% - repository not reachable, skipping.
    call :warn "%git_folder% - repository not reachable, skipped"
    echo.
    goto :eof
)

echo %green%::::::::::::::: Installing%yellow% %git_folder% %green%:::::::::::::::%reset%
echo.

git.exe -c credential.interactive=never clone "%git_url%" "ComfyUI/custom_nodes/%git_folder%"
if errorlevel 1 (
    echo %yellow%[SKIPPED]%reset% %git_folder% could not be downloaded, skipping.
    call :warn "%git_folder% - could not be downloaded, skipped"
    echo.
    goto :eof
)

setlocal enabledelayedexpansion
if exist ".\ComfyUI\custom_nodes\%git_folder%\requirements.txt" (
    for %%F in (".\ComfyUI\custom_nodes\%git_folder%\requirements.txt") do set filesize=%%~zF
    if not !filesize! equ 0 (
        .\python_embeded\python.exe -I -m uv pip install -r ".\ComfyUI\custom_nodes\%git_folder%\requirements.txt" %UVargs%
        if errorlevel 1 call :err
    )
)

if exist ".\ComfyUI\custom_nodes\%git_folder%\install.py" (
    for %%F in (".\ComfyUI\custom_nodes\%git_folder%\install.py") do set filesize=%%~zF
    if not !filesize! equ 0 (
	.\python_embeded\python.exe -I ".\ComfyUI\custom_nodes\%git_folder%\install.py"
	if errorlevel 1 call :err
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

if not defined NV_SMI goto :NV_WMI
for /f %%a in ('nvidia-smi --query-gpu^=driver_version --format^=csv^,noheader 2^>nul') do set "NV_FULL=%%a"

:NV_WMI
if not defined NV_FULL for /f "usebackq delims=" %%a in (`powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$v = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -like '*NVIDIA*' -and $_.DriverVersion } | Select-Object -First 1 -ExpandProperty DriverVersion; if ($v) { $d = $v -replace '[^0-9]', ''; if ($d.Length -ge 5) { $d = $d.Substring($d.Length - 5); $d.Substring(0, 3) + '.' + $d.Substring(3) } }" 2^>nul`) do set "NV_FULL=%%a"
if not defined NV_FULL if not defined NV_SMI (
    echo.
    echo %warning%WARNING:%reset% %red%NVIDIA driver not detected%reset%
    echo This installer requires an %yellow%NVIDIA GPU%reset% with an installed driver
    echo Install the latest driver from %yellow%https://www.nvidia.com/drivers%reset% and run this installer again
    call :fatal "NVIDIA driver not detected" "This installer needs an NVIDIA GPU with an installed driver. Install the latest driver from nvidia.com/drivers and run the installer again."
    echo Press any key to Exit...&Pause>nul
    set "FATAL=1"
    goto :eof
)
if not defined NV_SMI (
    echo.
    echo %warning%WARNING:%reset% nvidia-smi was not found - the NVIDIA driver %yellow%%NV_FULL%%reset% could not be fully checked
    echo If ComfyUI does not see your GPU, reinstall the NVIDIA driver from %yellow%https://www.nvidia.com/drivers%reset%
    call :warn "nvidia-smi was not found - the NVIDIA driver could not be fully checked. If ComfyUI does not see the GPU, reinstall the NVIDIA driver."
)
for /f "tokens=1 delims=." %%a in ("%NV_FULL%") do set "NV_MAJOR=%%a"

echo %NV_MAJOR%| findstr /R "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo.
    echo %warning%WARNING:%reset% %red%Unable to read NVIDIA driver version%reset%
    echo Make sure the NVIDIA driver is working ^(run %yellow%nvidia-smi%reset% in a terminal to check^)
    call :fatal "Cannot read the NVIDIA driver version" "Make sure the driver works - run nvidia-smi in a terminal to check. Updating the driver usually helps."
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
	call :warn "NVIDIA driver %NV_FULL% is older than %NV_MIN% - using CUDA 12.8. Updating the driver is recommended"
	set "CURRENT_CUDA=12.8"
)
call :info "NVIDIA driver %NV_FULL%, CUDA %CURRENT_CUDA%"

GOTO :EOF