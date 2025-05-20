@echo off
Title ComfyUI Easy Install by ivo v0.48.0 (Ep48)
:: Pixaroma Community Edition ::

:: Set colors ::
call :set_colors

:: Set No Warnings ::
set "silent=--no-cache-dir --no-warn-script-location"

:: Set Local Paths ::
if exist %windir%\system32 set path=%PATH%;%windir%\System32
if exist %windir%\system32\WindowsPowerShell\v1.0 set path=%PATH%;%windir%\system32\WindowsPowerShell\v1.0
if exist %localappdata%\Microsoft\WindowsApps set path=%PATH%;%localappdata%\Microsoft\WindowsApps

:: Check for Existing ComfyUI Folder ::
if exist ComfyUI-Easy-Install (
	echo %warning%WARNING:%reset% '%bold%ComfyUI-Easy-Install%reset%' folder already exists!
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	goto :eof
)

:: Check for Existing Helper-CEI.zip ::
if not exist Helper-CEI.zip (
	echo %warning%WARNING:%reset% '%bold%Helper-CEI.zip%reset%' not exists!
	echo %green%Unzip the entire package and try again.%reset%
	echo Press any key to Exit...&Pause>nul
	goto :eof
)

:: Capture the start time ::
for /f %%i in ('powershell -command "Get-Date -Format HH:mm:ss"') do set start=%%i

:: Clear Pip Cache ::
if exist "%localappdata%\pip\cache" rd /s /q "%localappdata%\pip\cache"&&md "%localappdata%\pip\cache"
echo %green%::::::::::::::: Clearing Pip Cache %yellow%Done%green% :::::::::::::::%reset%
echo.

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

:: Install pylatexenc for kokoro ::
REM curl.exe -OL https://www.piwheels.org/simple/pylatexenc/pylatexenc-3.0a32-py3-none-any.whl --ssl-no-revoke
REM .\python_embeded\python.exe -m pip install pylatexenc-3.0a32-py3-none-any.whl %silent%
REM if exist pylatexenc-3.0a32-py3-none-any.whl erase pylatexenc-3.0a32-py3-none-any.whl
.\python_embeded\python.exe -m pip install https://www.piwheels.org/simple/pylatexenc/pylatexenc-3.0a32-py3-none-any.whl %silent%
Echo.

call :get_node https://github.com/stavsap/comfyui-kokoro						comfyui-kokoro
call :get_node https://github.com/CY-CHENYUE/ComfyUI-Janus-Pro					janus-pro
call :get_node https://github.com/smthemex/ComfyUI_Sonic						ComfyUI_Sonic
call :get_node https://github.com/welltop-cn/ComfyUI-TeaCache					teacache
call :get_node https://github.com/kk8bit/KayTool								kaytool
call :get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion				ComfyUI-TiledDiffusion
call :get_node https://github.com/Lightricks/ComfyUI-LTXVideo					ComfyUI-LTXVideo
call :get_node https://github.com/kijai/ComfyUI-KJNodes							comfyui-kjnodes

:: Install onnxruntime ::
.\python_embeded\python.exe -m pip install onnxruntime-gpu %silent%

:: Extract 'update' folder ::
cd ..\
tar -xf .\Helper-CEI.zip
cd ComfyUI-Easy-Install

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

:install_git
:: https://git-scm.com/
echo %green%::::::::::::::: Installing/Updating%yellow% Git %green%:::::::::::::::%reset%
echo.
winget install --id Git.Git -e --source winget
set path=%PATH%;%ProgramFiles%\Git\cmd
echo.
goto :eof

:install_comfyui
:: https://github.com/comfyanonymous/ComfyUI
echo %green%::::::::::::::: Installing%yellow% ComfyUI %green%:::::::::::::::%reset%
echo.
git clone https://github.com/comfyanonymous/ComfyUI ComfyUI
curl -OL https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip --ssl-no-revoke
md python_embeded&&cd python_embeded
tar -xf ..\python-3.11.9-embed-amd64.zip
erase ..\python-3.11.9-embed-amd64.zip
curl -sSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py --ssl-no-revoke
.\python.exe get-pip.py %silent%
Echo ../ComfyUI> python311._pth
Echo python311.zip>> python311._pth
Echo .>> python311._pth
Echo import site>> python311._pth
.\python.exe -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 %silent%
.\python.exe -m pip install pygit2 %silent%
cd ..\ComfyUI
..\python_embeded\python.exe -m pip install -r requirements.txt %silent%
cd ..\
echo.
goto :eof

:get_node
set git_url=%~1
:: for %%x in (%git_url:/= %) do set git_folder=%%x
set git_folder=%~2
echo %green%::::::::::::::: Installing%yellow% %git_folder% %green%:::::::::::::::%reset%
echo.
git clone %git_url% ComfyUI/custom_nodes/%git_folder%
if exist .\ComfyUI\custom_nodes\%git_folder%\requirements.txt (
	.\python_embeded\python.exe -m pip install -r .\ComfyUI\custom_nodes\%git_folder%\requirements.txt --use-pep517 %silent%
)
if exist .\ComfyUI\custom_nodes\%git_folder%\install.py (
	.\python_embeded\python.exe .\ComfyUI\custom_nodes\%git_folder%\install.py
)
echo.
goto :eof

:copy_files
if exist ..\%~1 (if exist .\%~2 copy ..\%~1 .\%~2\>nul)
goto :eof
