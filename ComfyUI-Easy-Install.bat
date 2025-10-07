@Echo off&&cd /D %~dp0
Title ComfyUI-Easy-Install NEXT by ivo v1.65.0 (Ep65)
:: Pixaroma Community Edition ::

:: Set the Python version here (3.11 or 3.12 only) ::
set "PYTHON_VERSION=3.12"

:: Set colors ::
call :set_colors

:: Check the Python version ::
if not "%PYTHON_VERSION%"=="3.11" if not "%PYTHON_VERSION%"=="3.12" (
    echo.
    echo %warning%WARNING: %red%Python %PYTHON_VERSION% is not supported. %green%Supported versions: 3.11, 3.12%reset%
    echo.
    echo %red%::::::::::::::: Press any key to exit%reset%&Pause>nul
    exit
)

:: Set Ignoring Large File Storage ::
set GIT_LFS_SKIP_SMUDGE=1

:: Set arguments ::
set "PIPargs=--no-cache-dir --no-warn-script-location --timeout=1000 --retries 200"
set "CURLargs=--retry 200 --retry-all-errors"
set "UVargs=--no-cache --link-mode=copy"

:: Set local path only (temporarily) ::
for /f "delims=" %%G in ('cmd /c "where git.exe 2>nul"') do (set "GIT_PATH=%%~dpG")
set path=%GIT_PATH%
if exist %windir%\System32 set path=%PATH%;%windir%\System32
if exist %windir%\System32\WindowsPowerShell\v1.0 set path=%PATH%;%windir%\System32\WindowsPowerShell\v1.0
if exist %localappdata%\Microsoft\WindowsApps set path=%PATH%;%localappdata%\Microsoft\WindowsApps

:: Check for Existing ComfyUI Folder ::
if exist ComfyUI-Easy-Install (
	echo %warning%WARNING:%reset% '%bold%ComfyUI-Easy-Install%reset%' folder already exists!
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	goto :eof
)

:: Check for Existing Helper-CEI ::
set "HLPR_NAME=Helper-CEI-NEXT.zip"
if not exist %HLPR_NAME% (
	echo %warning%WARNING:%reset% '%bold%%HLPR_NAME%%reset%' not exists!
	echo %green%Unzip the entire package and try again.%reset%
	echo Press any key to Exit...&Pause>nul
	goto :eof
)

:: Capture the start time ::
for /f %%i in ('powershell -command "Get-Date -Format HH:mm:ss"') do set start=%%i

:: Clear Pip and uv Cache ::
call :clear_pip_uv_cache

:: Install/Update Git ::
call :install_git

:: Check if git is installed ::
for /F "tokens=*" %%g in ('git --version') do (set gitversion=%%g)
Echo %gitversion% | findstr /C:"version">nul&&(
	Echo %bold%git%reset% %yellow%is installed%reset%
	Echo.) || (
    Echo %warning%WARNING:%reset% %bold%'git'%reset% is NOT installed
	Echo Please install %bold%'git'%reset% manually from %yellow%https://git-scm.com/%reset% and run this installer again
	Echo Press any key to Exit...&Pause>nul
	exit /b
)

:: System folder? ::
md ComfyUI-Easy-Install
if not exist ComfyUI-Easy-Install (
	cls
	echo %warning%WARNING:%reset% Cannot create folder %yellow%ComfyUI-Easy-Install%reset%
	echo Make sure you are NOT using system folders like %yellow%Program Files, Windows%reset% or system root %yellow%C:\%reset%
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit /b
)
cd ComfyUI-Easy-Install

:: Install ComfyUI ::
call :install_comfyui

:: Install working version of stringzilla (damn it) ::
.\python_embeded\python.exe -I -m uv pip install stringzilla==3.12.6 %UVargs%
echo.

:: Install Pixaroma's Related Nodes ::
call :get_node https://github.com/Comfy-Org/ComfyUI-Manager						comfyui-manager
call :get_node https://github.com/WASasquatch/was-node-suite-comfyui			was-node-suite-comfyui
call :get_node https://github.com/yolain/ComfyUI-Easy-Use						ComfyUI-Easy-Use
call :get_node https://github.com/Fannovel16/comfyui_controlnet_aux				comfyui_controlnet_aux
call :get_node https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes			ComfyUI_Comfyroll_CustomNodes
call :get_node https://github.com/crystian/ComfyUI-Crystools					ComfyUI-Crystools
call :get_node https://github.com/rgthree/rgthree-comfy							rgthree-comfy
call :get_node https://github.com/city96/ComfyUI-GGUF							ComfyUI-GGUF
call :get_node https://github.com/kijai/ComfyUI-Florence2						ComfyUI-Florence2
if "%PYTHON_VERSION%"=="3.11" (call :get_node https://github.com/SeargeDP/ComfyUI_Searge_LLM ComfyUI_Searge_LLM)
call :get_node https://github.com/SeargeDP/ComfyUI_Searge_LLM					ComfyUI_Searge_LLM
call :get_node https://github.com/gseth/ControlAltAI-Nodes						controlaltai-nodes
call :get_node https://github.com/stavsap/comfyui-ollama						comfyui-ollama
call :get_node https://github.com/MohammadAboulEla/ComfyUI-iTools				comfyui-itools
call :get_node https://github.com/spinagon/ComfyUI-seamless-tiling				comfyui-seamless-tiling
call :get_node https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch		comfyui-inpaint-cropandstitch
call :get_node https://github.com/Lerc/canvas_tab								canvas_tab
call :get_node https://github.com/1038lab/ComfyUI-OmniGen						comfyui-omnigen
call :get_node https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg				comfyui-inspyrenet-rembg
call :get_node https://github.com/kaibioinfo/ComfyUI_AdvancedRefluxControl		ComfyUI_AdvancedRefluxControl
call :get_node https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite			comfyui-videohelpersuite
call :get_node https://github.com/PowerHouseMan/ComfyUI-AdvancedLivePortrait	comfyui-advancedliveportrait
call :get_node https://github.com/Yanick112/ComfyUI-ToSVG						ComfyUI-ToSVG
call :get_node https://github.com/stavsap/comfyui-kokoro						comfyui-kokoro
call :get_node https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro					janus-pro
call :get_node https://github.com/smthemex/ComfyUI_Sonic						ComfyUI_Sonic
call :get_node https://github.com/welltop-cn/ComfyUI-TeaCache					teacache
call :get_node https://github.com/kk8bit/KayTool								kaytool
call :get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion				ComfyUI-TiledDiffusion
call :get_node https://github.com/Lightricks/ComfyUI-LTXVideo					ComfyUI-LTXVideo
call :get_node https://github.com/kijai/ComfyUI-KJNodes							comfyui-kjnodes
call :get_node https://github.com/kijai/ComfyUI-WanVideoWrapper					ComfyUI-WanVideoWrapper
call :get_node https://github.com/Enemyx-net/VibeVoice-ComfyUI					VibeVoice-ComfyUI

echo %green%::::::::::::::: Installing %yellow%Required Dependencies%green% :::::::::::::::%reset%
echo.

:: Install llama-cpp-python for Searge ::
if "%PYTHON_VERSION%"=="3.12" (.\python_embeded\python.exe -I -m uv pip install https://github.com/abetlen/llama-cpp-python/releases/download/v0.3.4-cu124/llama_cpp_python-0.3.4-cp312-cp312-win_amd64.whl %UVargs%)
:: Install pylatexenc for kokoro ::
.\python_embeded\python.exe -I -m uv pip install https://www.piwheels.org/simple/pylatexenc/pylatexenc-3.0a32-py3-none-any.whl %UVargs%
:: Install onnxruntime ::
.\python_embeded\python.exe -I -m uv pip install onnxruntime-gpu %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnx %UVargs%
:: Install flet for REMBG ::
.\python_embeded\python.exe -I -m uv pip install flet %UVargs%
:: Install ffmpeg ::
.\python_embeded\python.exe -I -m uv pip install python-ffmpeg %UVargs%

:: Extracting helper folders ::
cd ..\
tar.exe -xf .\%HLPR_NAME%
cd ComfyUI-Easy-Install
if "%PYTHON_VERSION%"=="3.11" (xcopy "python_embeded_3.11\*" "python_embeded\" /E /Y /I /Q)
if "%PYTHON_VERSION%"=="3.12" (xcopy "python_embeded_3.12\*" "python_embeded\" /E /Y /I /Q)
if exist "python_embeded_3.11" rmdir /s /q "python_embeded_3.11"
if exist "python_embeded_3.12" rmdir /s /q "python_embeded_3.12"

:: INSTALLING Add-Ons :::
:: Installing Nunchaku ::
REM pushd %CD%&&echo.&&call Add-Ons\Nunchaku-NEXT.bat NoPause&&popd
:: Installing Insightface ::
REM pushd %CD%&&echo.&&call Add-Ons\Insightface-NEXT.bat NoPause&&popd
:: Installing SageAttention ::
REM pushd %CD%&&echo.&&call Add-Ons\SageAttention-NEXT.bat NoPause&&popd

:: Copy additional files if they exist ::
call :copy_files run_nvidia_gpu.bat		.\
call :copy_files extra_model_paths.yaml	ComfyUI
call :copy_files comfy.settings.json	ComfyUI\user\default
call :copy_files was_suite_config.json	ComfyUI\custom_nodes\was-node-suite-comfyui
call :copy_files rgthree_config.json	ComfyUI\custom_nodes\rgthree-comfy

:: Capture the end time ::
for /f %%i in ('powershell -command "Get-Date -Format HH:mm:ss"') do set end=%%i
for /f %%i in ('powershell -command "(New-TimeSpan -Start (Get-Date '%start%') -End (Get-Date '%end%')).TotalSeconds"') do set diff=%%i

:: Final Messages ::
echo.
echo %green%::::::::::::::: Installation Complete :::::::::::::::%reset%
echo %green%::::::::::::::: Total Running Time:%red% %diff% %green%seconds%reset%
echo %yellow%::::::::::::::: Press any key to exit :::::::::::::::%reset%&Pause>nul
goto :eof

::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::

:set_colors
set warning=[33m
set     red=[91m
set   green=[92m
set  yellow=[93m
set    bold=[1m
set   reset=[0m
goto :eof

:clear_pip_uv_cache
if exist "%localappdata%\pip\cache" rd /s /q "%localappdata%\pip\cache"&&md "%localappdata%\pip\cache"
if exist "%localappdata%\uv\cache" rd /s /q "%localappdata%\uv\cache"&&md "%localappdata%\uv\cache"
echo %green%::::::::::::::: Clearing Pip and uv Cache %yellow%Done%green% :::::::::::::::%reset%
echo.
goto :eof

:install_git
:: https://git-scm.com/
echo %green%::::::::::::::: Installing/Updating%yellow% Git %green%:::::::::::::::%reset%
echo.

:: Winget Install: ms-windows-store://pdp/?productid=9NBLGGH4NNS1 ::
winget.exe install --id Git.Git -e --source winget
set path=%PATH%;%ProgramFiles%\Git\cmd
echo.
goto :eof

:install_comfyui
:: https://github.com/comfyanonymous/ComfyUI
echo %green%::::::::::::::: Installing%yellow% ComfyUI %green%:::::::::::::::%reset%
echo.
git.exe clone https://github.com/comfyanonymous/ComfyUI ComfyUI

if "%PYTHON_VERSION%"=="3.11" (set "PYTHON_VER=3.11.9")
if "%PYTHON_VERSION%"=="3.12" (set "PYTHON_VER=3.12.10")

md python_embeded&&cd python_embeded
curl.exe -OL https://www.python.org/ftp/python/%PYTHON_VER%/python-%PYTHON_VER%-embed-amd64.zip --ssl-no-revoke %CURLargs%
tar.exe -xf python-%PYTHON_VER%-embed-amd64.zip
erase python-%PYTHON_VER%-embed-amd64.zip
curl.exe -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py --ssl-no-revoke %CURLargs%

Echo ../ComfyUI> python311._pth
Echo ../ComfyUI> python312._pth
Echo python311.zip>> python311._pth
Echo python312.zip>> python312._pth
Echo .>> python311._pth
Echo .>> python312._pth
Echo Lib/site-packages>> python311._pth
Echo Lib/site-packages>> python312._pth
Echo Lib>> python311._pth
Echo Lib>> python312._pth
Echo Scripts>> python311._pth
Echo Scripts>> python312._pth
Echo # import site>> python311._pth
Echo # import site>> python312._pth

.\python.exe -I get-pip.py %PIPargs%
.\python.exe -I -m pip install uv %PIPargs%
.\python.exe -I -m pip install torch==2.8.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 %PIPargs%
.\python.exe -I -m uv pip install pygit2 %UVargs%
cd ..\ComfyUI
..\python_embeded\python.exe -I -m uv pip install -r requirements.txt %UVargs%
cd ..\
echo.
goto :eof

:get_node
set git_url=%~1
set git_folder=%~2
echo %green%::::::::::::::: Installing%yellow% %git_folder% %green%:::::::::::::::%reset%
echo.
git.exe clone %git_url% ComfyUI/custom_nodes/%git_folder%
if exist .\ComfyUI\custom_nodes\%git_folder%\requirements.txt (
	.\python_embeded\python.exe -I -m uv pip install -r .\ComfyUI\custom_nodes\%git_folder%\requirements.txt %UVargs%
)
if exist .\ComfyUI\custom_nodes\%git_folder%\install.py (
	.\python_embeded\python.exe -I .\ComfyUI\custom_nodes\%git_folder%\install.py
)
echo.
goto :eof

:copy_files
if exist ..\%~1 (if exist .\%~2 copy ..\%~1 .\%~2\>nul)
goto :eof
