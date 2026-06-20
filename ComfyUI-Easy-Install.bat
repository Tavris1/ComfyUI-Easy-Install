@echo off&&cd /D %~dp0
set "CEI_Title=ComfyUI-Easy-Install by ivo v3.8.1"
Title %CEI_Title%
:: Pixaroma Community Edition ::

set "GIT_TERMINAL_PROMPT=0"
set "GIT_ASKPASS=echo"

:: Set Ignoring Large File Storage ::
set GIT_LFS_SKIP_SMUDGE=1

:: Set arguments ::
set "PIPargs=--no-cache-dir --no-warn-script-location --timeout=1000 --retries 10"
set "UVargs=--no-cache --link-mode=copy"

:: Add a path just in case ::
for /f "delims=" %%G in ('cmd /c "where.exe git.exe 2>nul"') do (set "GIT_PATH=%%~dpG")
set "path=%GIT_PATH%;%windir%\System32;%windir%\System32\WindowsPowerShell\v1.0;%localappdata%\Microsoft\WindowsApps;%path%"

call :SET_COLORS
call :NVIDIA_DRIVER_CHECK

:: Check for Existing ComfyUI Folder ::
if exist ComfyUI-Easy-Install if exist "ComfyUI-Easy-Install" (
	echo %warning%WARNING:%reset% '%bold%ComfyUI-Easy-Install%reset%' folder already exists!
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	goto :eof
)

:: Check for Existing Helper-CEI ::
set "HLPR_NAME=Helper-CEI.zip"
if not exist "%HLPR_NAME%" (
	echo %warning%WARNING:%reset% '%bold%%HLPR_NAME%%reset%' not exists!
	echo %green%Unzip the entire package and try again.%reset%
	echo Press any key to Exit...&Pause>nul
	goto :eof
)

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
echo    %BGR%000000000 %FGR%DESKTOP%BGR% 0000000000
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
	exit
)

:: System folder? ::
md "ComfyUI-Easy-Install"
if not exist "ComfyUI-Easy-Install" (
	cls
	echo %warning%WARNING:%reset% Cannot create folder %yellow%ComfyUI-Easy-Install%reset%
	echo Make sure you are NOT using system folders like %yellow%Program Files, Windows%reset% or system root %yellow%C:\%reset%
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit
)
cd "ComfyUI-Easy-Install"

:: Install ComfyUI ::
call :install_comfyui

echo %green%::::::::::::::: %yellow%Pre-installation of required modules%green% :::::::::::::::%reset%
echo.
REM .\python_embeded\python.exe -I -m uv pip install requests==2.31.0 urllib3==2.6.3 charset_normalizer==3.4.4
.\python_embeded\python.exe -I -m uv pip install scipy==1.17.1 %UVargs%
.\python_embeded\python.exe -I -m uv pip install chardet==5.2.0 %UVargs%
.\python_embeded\python.exe -I -m uv pip install scikit-build-core %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnxruntime-gpu %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnx %UVargs%
.\python_embeded\python.exe -I -m uv pip install flet %UVargs%
.\python_embeded\python.exe -I -m uv pip install pywebview %UVargs%
.\python_embeded\python.exe -I -m uv pip install -r ".\ComfyUI\manager_requirements.txt" %UVargs%

if "%CURRENT_CUDA%"=="12.8" (
	.\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.33-cu128-Basic-win-20260315/llama_cpp_python-0.3.33+cu128.basic-cp312-cp312-win_amd64.whl %UVargs%
) else (
	.\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.33-cu130-Basic-win-20260315/llama_cpp_python-0.3.33+cu130.basic-cp312-cp312-win_amd64.whl %UVargs%
)

:: Install working version of stringzilla (damn it) ::
.\python_embeded\python.exe -I -m uv pip install stringzilla==3.12.6 %UVargs%
:: Install working version of transformers (damn it again)::
.\python_embeded\python.exe -I -m uv pip install transformers==4.57.6 %UVargs%
.\python_embeded\python.exe -I -m uv pip install descript-audio-codec %UVargs%
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
call :get_node https://github.com/Saganaki22/ComfyUI-FishAudioS2			ComfyUI-fish-audio-s2

call :get_node https://gitlab.com/pixaroma/ComfyUI-Pixaroma.git				ComfyUI-Pixaroma

:: Check if SoX is already installed - skip silently if found
where sox.exe >nul 2>&1
if not errorlevel 1 goto SkipSoX

echo.
echo %green%::::::::::::::::::::: %yellow%Checking SoX%green% :::::::::::::::::::::%reset%
echo.
winget.exe list --id ChrisBagwell.SoX 2>nul | findstr /i "ChrisBagwell.SoX" >nul
if errorlevel 1 (
    echo %green%:::::::::::::::::::: %yellow%Installing SoX%green% ::::::::::::::::::::%reset%
    winget.exe install --id ChrisBagwell.SoX -e --accept-source-agreements --accept-package-agreements --silent
) else (
    winget.exe upgrade --id ChrisBagwell.SoX -e --accept-source-agreements --accept-package-agreements --silent >nul 2>nul
)

:SkipSoX
cd .\
echo.


if not exist ".\ComfyUI\custom_nodes\.disabled" mkdir ".\ComfyUI\custom_nodes\.disabled"

:: Extracting helper folders ::
cd ..\
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Microsoft.PowerShell.Archive\Expand-Archive -LiteralPath '%HLPR_NAME%' -DestinationPath '.' -Force"

cd ComfyUI-Easy-Install

:: Install Triton ::
if "%CURRENT_CUDA%"=="12.8" (
	.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.5" %PIPargs%
) else (
	.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.6" %PIPargs%
)


.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.6" %PIPargs%
:: Postinstall
.\python_embeded\python.exe -I -m uv pip uninstall pydantic pydantic-core
.\python_embeded\python.exe -I -m uv pip install pydantic %UVargs%
echo.

if exist ".\Add-Ons\Tools\AutoRun.bat" (
	pushd %cd%
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

exit

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

:install_git
:: https://git-scm.com/
echo %green%::::::::::::::: Installing/Updating%yellow% Git %green%:::::::::::::::%reset%
echo.

:: Winget Install: ms-windows-store://pdp/?productid=9NBLGGH4NNS1 ::
winget.exe install --id Git.Git -e --source winget
set "path=%PATH%;%ProgramFiles%\Git\cmd"
echo.
goto :eof

:install_comfyui
:: https://github.com/comfyanonymous/ComfyUI
echo %green%::::::::::::::: Installing%yellow% ComfyUI %green%:::::::::::::::%reset%
echo.

git.exe clone https://github.com/Comfy-Org/ComfyUI ComfyUI

md python_embeded&&cd python_embeded

curl.exe -L --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "python-3.12.10-embed-amd64.zip" "https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip"
if errorlevel 1 curl.exe -L --progress-bar --ssl-no-revoke -k --retry 5 --retry-delay 2 -o "python-3.12.10-embed-amd64.zip" "https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip"
if errorlevel 1 powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip' -Destination 'python-3.12.10-embed-amd64.zip' -ErrorAction Stop}catch{exit 1}"
if not exist "python-3.12.10-embed-amd64.zip" (
echo.
echo %red%Failed to download python-3.12.10-embed-amd64.zip%reset%
echo Press any key to Exit...&Pause>nul
exit
)

tar.exe -xmf python-3.12.10-embed-amd64.zip
if errorlevel 1 powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath 'python-3.12.10-embed-amd64.zip' -DestinationPath '.' -Force"
erase python-3.12.10-embed-amd64.zip

curl.exe -L --progress-bar --ssl-no-revoke --retry 5 --retry-delay 2 -o "get-pip.py" "https://bootstrap.pypa.io/get-pip.py"
if errorlevel 1 curl.exe -L --progress-bar --ssl-no-revoke -k --retry 5 --retry-delay 2 -o "get-pip.py" "https://bootstrap.pypa.io/get-pip.py"
if errorlevel 1 powershell -NoProfile -ExecutionPolicy Bypass -Command "Try{Start-BitsTransfer -Source 'https://bootstrap.pypa.io/get-pip.py' -Destination 'get-pip.py' -ErrorAction Stop}catch{exit 1}"
if not exist "get-pip.py" (
echo.
echo %red%Failed to download get-pip.py%reset%
echo Press any key to Exit...&Pause>nul
exit
)

echo ../ComfyUI> python312._pth
echo python312.zip>> python312._pth
echo .>> python312._pth
echo Lib/site-packages>> python312._pth
echo Lib>> python312._pth
echo Scripts>> python312._pth
echo # import site>> python312._pth

echo [global]> pip.ini
echo trusted-host =>> pip.ini
echo     pypi.org>> pip.ini
echo     files.pythonhosted.org>> pip.ini
echo     pypi.python.org>> pip.ini

.\python.exe -I get-pip.py %PIPargs% --trusted-host pypi.org --trusted-host files.pythonhosted.org --trusted-host pypi.python.org
REM .\python.exe -I -m pip config set global.trusted-host "pypi.org files.pythonhosted.org pypi.python.org"

.\python.exe -I -m pip install uv==0.9.7 %PIPargs%

if "%CURRENT_CUDA%"=="12.8" (
	.\python.exe -I -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/cu128 %PIPargs%
) else (
	.\python.exe -I -m pip install torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 --index-url https://download.pytorch.org/whl/cu130 %PIPargs%
)

.\python.exe -I -m uv pip install pygit2 %UVargs%
cd ..\ComfyUI

:: Install working version of av!!! ::
..\python_embeded\python.exe -I -m uv pip install av==16.0.1 %UVargs%

..\python_embeded\python.exe -I -m uv pip install -r requirements.txt %UVargs%
cd ..\
echo.
goto :eof

:get_node
set "git_url=%~1"
set "git_folder=%~2"
echo %green%::::::::::::::: Installing%yellow% %git_folder% %green%:::::::::::::::%reset%
echo.
git.exe clone %git_url% ComfyUI/custom_nodes/%git_folder%

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

where.exe nvidia-smi.exe >nul 2>&1
if %errorLevel% neq 0 (
    echo %red%   NVIDIA driver not detected
    GOTO :EOF
)

for /f %%a in ('nvidia-smi --query-gpu^=driver_version --format^=csv^,noheader 2^>nul') do set "NV_FULL=%%a"
for /f "tokens=1 delims=." %%a in ("%NV_FULL%") do set "NV_MAJOR=%%a"

if not defined NV_MAJOR (
    echo %red%   Unable to read NVIDIA driver version
    GOTO :EOF
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