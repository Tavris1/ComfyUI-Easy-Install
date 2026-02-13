@Echo off&&cd /D %~dp0
set "CEI_Title=ComfyUI-Easy-Install by ivo v2.04.0"
Title %CEI_Title%
:: Pixaroma Community Edition ::

:: Set colors ::
call :set_colors

:: Set Ignoring Large File Storage ::
set GIT_LFS_SKIP_SMUDGE=1

:: Set arguments ::
set "PIPargs=--no-cache-dir --no-warn-script-location --timeout=1000 --retries 10"
set "UVargs=--no-cache --link-mode=copy"

:: Set local path only (temporarily) ::
for /f "delims=" %%G in ('cmd /c "where.exe git.exe 2>nul"') do (set "GIT_PATH=%%~dpG")
set "path=%GIT_PATH%"
if exist "%windir%\System32" set "path=%PATH%;%windir%\System32"
if exist "%windir%\System32\WindowsPowerShell\v1.0" set "path=%PATH%;%windir%\System32\WindowsPowerShell\v1.0"
if exist "%localappdata%\Microsoft\WindowsApps" set "path=%PATH%;%localappdata%\Microsoft\WindowsApps"

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
for /f "delims=" %%i in ('powershell -command "Get-Date -Format yyyy-MM-dd_HH:mm:ss"') do set start=%%i

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
echo    %BGR%0000000000000000000000000000%reset%
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
md "ComfyUI-Easy-Install"
if not exist "ComfyUI-Easy-Install" (
	cls
	echo %warning%WARNING:%reset% Cannot create folder %yellow%ComfyUI-Easy-Install%reset%
	echo Make sure you are NOT using system folders like %yellow%Program Files, Windows%reset% or system root %yellow%C:\%reset%
	echo %green%Move this file to another folder and run it again.%reset%
	echo Press any key to Exit...&Pause>nul
	exit /b
)
cd "ComfyUI-Easy-Install"

:: Install ComfyUI ::
call :install_comfyui

echo %green%::::::::::::::: %yellow%Pre-installation of required modules%green% :::::::::::::::%reset%
echo.
.\python_embeded\python.exe -I -m uv pip install scikit-build-core %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnxruntime-gpu %UVargs%
.\python_embeded\python.exe -I -m uv pip install onnx %UVargs%
.\python_embeded\python.exe -I -m uv pip install flet %UVargs%
.\python_embeded\python.exe -I -m uv pip install https://github.com/JamePeng/llama-cpp-python/releases/download/v0.3.24-cu130-Basic-win-20260208/llama_cpp_python-0.3.24+cu130.basic-cp312-cp312-win_amd64.whl %UVargs%
:: Install working version of stringzilla (damn it) ::
.\python_embeded\python.exe -I -m uv pip install stringzilla==3.12.6 %UVargs%
:: Install working version of transformers (damn it again)::
.\python_embeded\python.exe -I -m uv pip install transformers==4.57.6 %UVargs%
echo.

:: Install Pixaroma's Related Nodes ::
call :get_node https://github.com/Comfy-Org/ComfyUI-Manager						comfyui-manager
call :get_node https://github.com/yolain/ComfyUI-Easy-Use						ComfyUI-Easy-Use
call :get_node https://github.com/Fannovel16/comfyui_controlnet_aux				comfyui_controlnet_aux
call :get_node https://github.com/rgthree/rgthree-comfy							rgthree-comfy
call :get_node https://github.com/MohammadAboulEla/ComfyUI-iTools				comfyui-itools
call :get_node https://github.com/city96/ComfyUI-GGUF							ComfyUI-GGUF
call :get_node https://github.com/gseth/ControlAltAI-Nodes						controlaltai-nodes
call :get_node https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch		comfyui-inpaint-cropandstitch
call :get_node https://github.com/1038lab/ComfyUI-RMBG							comfyui-rmbg
call :get_node https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite			comfyui-videohelpersuite
call :get_node https://github.com/shiimizu/ComfyUI-TiledDiffusion				ComfyUI-TiledDiffusion
call :get_node https://github.com/kijai/ComfyUI-KJNodes							comfyui-kjnodes
call :get_node https://github.com/kijai/ComfyUI-WanVideoWrapper					ComfyUI-WanVideoWrapper
call :get_node https://github.com/1038lab/ComfyUI-QwenVL						ComfyUI-QwenVL
call :get_node https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler			seedvr2_videoupscaler

if not exist ".\ComfyUI\custom_nodes\.disabled" mkdir ".\ComfyUI\custom_nodes\.disabled"

:: Extracting helper folders ::
cd ..\
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '%HLPR_NAME%' -DestinationPath '.' -Force"
cd ComfyUI-Easy-Install

:: Install Triton for Torch 2.9 ::
.\python_embeded\python.exe -I -m pip install --upgrade --force-reinstall "triton-windows<3.6" %PIPargs%
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

:: Clear Pip and uv Cache ::
REM call :clear_pip_uv_cache

:: Capture the end time ::
for /f "delims=" %%i in ('powershell -command "Get-Date -Format yyyy-MM-dd_HH:mm:ss"') do set end=%%i
for /f "delims=" %%i in ('powershell -command "$s=[datetime]::ParseExact('%start%','yyyy-MM-dd_HH:mm:ss',$null); $e=[datetime]::ParseExact('%end%','yyyy-MM-dd_HH:mm:ss',$null); if($e -lt $s){$e=$e.AddDays(1)}; ($e-$s).TotalSeconds"') do set diff=%%i

:: Final Messages ::
echo %green%::::::::::::::::: Installation Complete ::::::::::::::::%reset%
echo %green%::::::::::::::::: Total Running Time:%red% %diff% %green%seconds%reset%
echo %yellow%::::::::::::::::: Press any key to exit ::::::::::::::::%reset%&Pause>nul

exit

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
echo %green%:::::::::::::::: Clearing Pip and uv Cache%green% :::::::::::::%reset%

set CACHE_DRIVE=%localappdata:~0,2%

for /f "delims=" %%A in ('
powershell -NoProfile -Command "$t=0;@('%localappdata%\pip\cache','%localappdata%\uv\cache')|%%{if(Test-Path $_){Get-ChildItem $_ -Recurse -Force -File -ErrorAction SilentlyContinue|%%{$t+=$_.Length};Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue}};New-Item -ItemType Directory '%localappdata%\pip\cache' -Force|Out-Null;New-Item -ItemType Directory '%localappdata%\uv\cache' -Force|Out-Null;if($t -eq 0){'Cache is already clean on %CACHE_DRIVE%'} elseif($t -ge 1GB){'Cleared {0:N1} GB on %CACHE_DRIVE%' -f ($t/1GB)} else {'Cleared {0} MB on %CACHE_DRIVE%' -f [math]::Floor($t/1MB)}"
') do set MSG=%%A

echo %green%:::::::::::::::: %yellow%%MSG%%reset%
echo.

goto :eof

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

REM git.exe clone https://github.com/comfyanonymous/ComfyUI ComfyUI
git.exe clone https://github.com/Comfy-Org/ComfyUI ComfyUI

:: Disable only CRL/OCSP checks for SSL ::
powershell -Command "[System.Net.ServicePointManager]::CheckCertificateRevocationList = $false"

:: Ignore SSL certificate errors ::
REM powershell -Command "Add-Type @'using System.Net;using System.Security.Cryptography.X509Certificates;public class TrustAllCertsPolicy : ICertificatePolicy {public bool CheckValidationResult(ServicePoint srvPoint,X509Certificate certificate,WebRequest request,int certificateProblem){return true;}}'@;[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy"

md python_embeded&&cd python_embeded
powershell -Command "try { Invoke-WebRequest 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip' -OutFile 'python-3.12.10-embed-amd64.zip' -UseBasicParsing -ErrorAction Stop } catch { curl.exe -L --ssl-no-revoke 'https://www.python.org/ftp/python/3.12.10/python-3.12.10-embed-amd64.zip' -o 'python-3.12.10-embed-amd64.zip' }"


tar.exe -xf python-3.12.10-embed-amd64.zip
REM powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath 'python-3.12.10-embed-amd64.zip' -DestinationPath '.' -Force"
erase python-3.12.10-embed-amd64.zip
powershell -Command "try { Invoke-WebRequest 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py' -UseBasicParsing -ErrorAction Stop } catch { curl.exe -sSL --ssl-no-revoke 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py' }"


Echo ../ComfyUI> python312._pth
Echo python312.zip>> python312._pth
Echo .>> python312._pth
Echo Lib/site-packages>> python312._pth
Echo Lib>> python312._pth
Echo Scripts>> python312._pth
Echo # import site>> python312._pth

.\python.exe -I get-pip.py %PIPargs%
.\python.exe -I -m pip install uv==0.9.7 %PIPargs%
REM .\python.exe -I -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/cu128 %PIPargs%
.\python.exe -I -m pip install torch==2.9.1 torchvision==0.24.1 torchaudio==2.9.1 --index-url https://download.pytorch.org/whl/cu130 %PIPargs%
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
