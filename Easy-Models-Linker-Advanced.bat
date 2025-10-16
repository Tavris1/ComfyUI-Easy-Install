@echo off
Title Easy-Models-Linker Advanced by ivo v1.65.0
:: Pixaroma Community Edition - Universal Windows Edition ::

setlocal enabledelayedexpansion

:: Set colors ::
set warning=[33m
set     red=[91m
set   green=[92m
set  yellow=[93m
set    blue=[94m
set    bold=[1m
set   reset=[0m

:: Initialize variables ::
set "main_folder="
set "yaml="

:main_menu
cls
echo %blue%%bold%Easy-Models-Linker Advanced%reset%
echo %green%======================================%reset%
echo %green%This tool creates an %yellow%extra_model_paths.yaml%green% configuration file.%reset%
if defined main_folder (
    echo %green%ComfyUI installation: %yellow%%main_folder%%reset%
) else (
    echo %yellow%ComfyUI installation: Not detected yet%reset%
)
echo.
echo %yellow%1.%reset% Auto-detect ComfyUI installation
echo %yellow%2.%reset% Manually specify ComfyUI path
echo %yellow%3.%reset% Link local models folder
echo %yellow%4.%reset% Link network mapped models folder
echo %yellow%5.%reset% Show current model paths configuration
echo %yellow%6.%reset% Remove existing configuration
echo %yellow%7.%reset% Exit
echo.
set /p choice="Select option (1-7): "

if "%choice%"=="1" goto :auto_detect_comfyui
if "%choice%"=="2" goto :manual_comfyui_path
if "%choice%"=="3" goto :link_local_models
if "%choice%"=="4" goto :link_network_models
if "%choice%"=="5" goto :show_current_config
if "%choice%"=="6" goto :remove_config
if "%choice%"=="7" goto :exit_script
echo %red%Invalid option. Please select 1-7.%reset%
timeout /t 2 >nul
goto :main_menu

:auto_detect_comfyui
cls
echo %yellow%Searching for ComfyUI installation...%reset%
echo.

:: Get current script directory
set "script_dir=%~dp0"
set "script_dir=%script_dir:~0,-1%"

:: Define search paths
set "search_paths[0]=%script_dir%\ComfyUI-Easy-Install\ComfyUI"
set "search_paths[1]=%script_dir%\ComfyUI"
set "search_paths[2]=%script_dir%\..\ComfyUI"
set "search_paths[3]=C:\ComfyUI"
set "search_paths[4]=C:\Program Files\ComfyUI"
set "search_paths[5]=C:\Program Files (x86)\ComfyUI"
set "search_paths[6]=D:\ComfyUI"
set "search_paths[7]=E:\ComfyUI"
set "search_paths[8]=%USERPROFILE%\ComfyUI"
set "search_paths[9]=%USERPROFILE%\Desktop\ComfyUI"
set "search_paths[10]=%USERPROFILE%\Documents\ComfyUI"
set "search_paths[11]=%LOCALAPPDATA%\ComfyUI"
set "search_paths[12]=%APPDATA%\ComfyUI"

:: Check each search path
for /L %%i in (0,1,12) do (
    if defined search_paths[%%i] (
        if exist "!search_paths[%%i]!\models" (
            set "main_folder=!search_paths[%%i]!"
            echo %green%Found ComfyUI at: %yellow%!main_folder!%reset%
            set "yaml=!main_folder!\extra_model_paths.yaml"
            echo.
            echo %yellow%Press any key to continue...%reset%
            pause >nul
            goto :main_menu
        )
    )
)

:: Check common drive letters for ComfyUI installations
echo %yellow%Checking additional locations...%reset%
for %%d in (C D E F G H) do (
    if exist "%%d:\ComfyUI-Easy-Install\ComfyUI\models" (
        set "main_folder=%%d:\ComfyUI-Easy-Install\ComfyUI"
        echo %green%Found ComfyUI at: %yellow%!main_folder!%reset%
        set "yaml=!main_folder!\extra_model_paths.yaml"
        echo.
        echo %yellow%Press any key to continue...%reset%
        pause >nul
        goto :main_menu
    )
)

echo %red%ComfyUI installation not found in standard locations.%reset%
echo %yellow%Please use option 2 to manually specify the path.%reset%
echo.
echo %yellow%Press any key to continue...%reset%
pause >nul
goto :main_menu

:manual_comfyui_path
cls
echo %yellow%Manual ComfyUI Path Specification%reset%
echo %green%=================================%reset%
echo.
echo %green%Please enter the full path to your ComfyUI installation:%reset%
echo %yellow%(The directory that contains the 'models' folder)%reset%
echo.
echo %yellow%Examples:%reset%
echo   C:\ComfyUI-Easy-Install\ComfyUI
echo   D:\AI\ComfyUI
echo   %USERPROFILE%\ComfyUI
echo.
set /p "manual_path=ComfyUI path: "

if "%manual_path%"=="" (
    echo Cancelled.
    echo.
    echo %yellow%Press any key to continue...%reset%
    pause >nul
    goto :main_menu
)

:: Remove trailing backslash if present
if "%manual_path:~-1%"=="\" set "manual_path=%manual_path:~0,-1%"

if not exist "%manual_path%" (
    echo %red%Error: Directory does not exist: %manual_path%%reset%
    echo.
    echo %yellow%Press any key to try again...%reset%
    pause >nul
    goto :manual_comfyui_path
)

if not exist "%manual_path%\models" (
    echo %red%Error: No 'models' directory found in: %manual_path%%reset%
    echo %yellow%Please ensure you're pointing to the ComfyUI root directory.%reset%
    echo.
    echo %yellow%Press any key to try again...%reset%
    pause >nul
    goto :manual_comfyui_path
)

set "main_folder=%manual_path%"
set "yaml=%main_folder%\extra_model_paths.yaml"
echo %green%ComfyUI installation confirmed at: %yellow%%main_folder%%reset%
echo.
echo %yellow%Press any key to continue...%reset%
pause >nul
goto :main_menu

:check_comfyui_set
if not defined main_folder (
    echo %red%Error: ComfyUI installation path not set.%reset%
    echo %yellow%Please use option 1 or 2 to detect/specify ComfyUI path first.%reset%
    echo.
    echo %yellow%Press any key to continue...%reset%
    pause >nul
    goto :main_menu
)
goto :eof

:link_local_models
cls
call :check_comfyui_set
if errorlevel 1 goto :main_menu

echo %green%Link Local Models Folder%reset%
echo %green%========================%reset%
echo.
echo %green%ComfyUI installation: %yellow%%main_folder%%reset%
echo.
echo %green%Select the location of your %yellow%EXISTING MODELS%green% folder.%reset%
echo %yellow%This should be a different folder from your current ComfyUI models.%reset%
echo.

:: Use PowerShell folder browser
for /f "delims=" %%i in ('powershell -command "$folder = New-Object -ComObject Shell.Application; $selection = $folder.BrowseForFolder(0, 'Select the location of your EXISTING MODELS folder', 512+1+64, 17); if($selection) { $selection.Self.Path }"') do set "models=%%i"

if not defined models (
    echo Cancelled.
    echo.
    echo %yellow%Press any key to continue...%reset%
    pause >nul
    goto :main_menu
)

echo %green%Selected: %yellow%%models%%reset%

call :validate_models_folder "%models%"
if errorlevel 1 (
    echo.
    echo %yellow%Press any key to try again...%reset%
    pause >nul
    goto :link_local_models
)

call :create_yaml_config "%models%"
goto :main_menu

:link_network_models
cls
call :check_comfyui_set
if errorlevel 1 goto :main_menu

echo %green%Link Network Mapped Models Folder%reset%
echo %green%=================================%reset%
echo.
echo %yellow%This option is for models stored on network drives (mapped drives, UNC paths, etc.)%reset%
echo.
echo %yellow%1.%reset% Browse for network mapped drive
echo %yellow%2.%reset% Enter UNC path manually (\\server\share\path)
echo %yellow%3.%reset% Back to main menu
echo.
set /p net_choice="Select option (1-3): "

if "%net_choice%"=="1" goto :browse_network_models
if "%net_choice%"=="2" goto :manual_network_path
if "%net_choice%"=="3" goto :main_menu
echo %red%Invalid option.%reset%
timeout /t 2 >nul
goto :link_network_models

:browse_network_models
echo %green%Select your network models folder:%reset%
for /f "delims=" %%i in ('powershell -command "$folder = New-Object -ComObject Shell.Application; $selection = $folder.BrowseForFolder(0, 'Select your network models folder', 512+1+64, 17); if($selection) { $selection.Self.Path }"') do set "models=%%i"

if not defined models (
    echo Cancelled.
    echo.
    echo %yellow%Press any key to continue...%reset%
    pause >nul
    goto :main_menu
)

echo %green%Selected: %yellow%%models%%reset%
call :validate_models_folder "%models%"
if errorlevel 1 (
    echo.
    echo %yellow%Press any key to try again...%reset%
    pause >nul
    goto :link_network_models
)

call :create_yaml_config "%models%"
goto :main_menu

:manual_network_path
echo %green%Enter UNC path to your network models folder:%reset%
echo %yellow%Example: \\server\share\ComfyUI-Models%reset%
echo.
set /p "network_path=Network path: "

if "%network_path%"=="" (
    echo Cancelled.
    echo.
    echo %yellow%Press any key to continue...%reset%
    pause >nul
    goto :main_menu
)

if not exist "%network_path%" (
    echo %red%Error: Network path does not exist or is not accessible: %network_path%%reset%
    echo %yellow%Make sure the network drive is mapped and accessible.%reset%
    echo.
    echo %yellow%Press any key to try again...%reset%
    pause >nul
    goto :manual_network_path
)

set "models=%network_path%"
call :validate_models_folder "%models%"
if errorlevel 1 (
    echo.
    echo %yellow%Press any key to try again...%reset%
    pause >nul
    goto :link_network_models
)

call :create_yaml_config "%models%"
goto :main_menu

:validate_models_folder
set "models_path=%~1"

if not exist "%models_path%" (
    echo %red%Error: Path does not exist: %models_path%%reset%
    exit /b 1
)

:: Check for common ComfyUI model subdirectories
set "found_dirs=0"
set "expected_dirs=checkpoints loras vae controlnet embeddings upscale_models"

for %%d in (%expected_dirs%) do (
    if exist "%models_path%\%%d" (
        set /a found_dirs+=1
    )
)

if %found_dirs%==0 (
    echo %warning%Warning: No standard ComfyUI model directories found.%reset%
    echo %yellow%Expected directories: %expected_dirs%%reset%
    set /p "continue_anyway=Continue anyway? (y/n): "
    if /i not "!continue_anyway!"=="y" (
        exit /b 1
    )
) else (
    echo %green%Found %found_dirs% standard model directories.%reset%
)

:: Check if it's the same as current ComfyUI models
if "%models_path%"=="%main_folder%\models" (
    echo %red%Error: Cannot link to the same folder as current ComfyUI models.%reset%
    exit /b 1
)

exit /b 0

:create_yaml_config
set "models_path=%~1"

:: Get the parent directory and folder name
for %%F in ("%models_path%") do (
    set "parent_dir=%%~dpF"
    set "models_name=%%~nxF"
)
:: Remove trailing backslash from parent_dir
if "%parent_dir:~-1%"=="\" set "parent_dir=%parent_dir:~0,-1%"

:: Create the YAML file
echo # Powered by Easy-Models-Linker Advanced and Ivo>"%yaml%"
echo # Pixaroma Community Edition>>"%yaml%"
echo # Generated on: %date% %time%>>"%yaml%"
echo # Models source: %models_path%>>"%yaml%"
echo.>>"%yaml%"
echo comfyui:>>"%yaml%"
echo     base_path: %parent_dir%\>>"%yaml%"
echo     is_default: true>>"%yaml%"
echo.>>"%yaml%"

:: Add each subdirectory to the YAML
set "added_dirs=0"
pushd "%models_path%"
for /D %%f in (*) do (
    echo     %%f: %models_name%\%%f\>>"%yaml%"
    set /a added_dirs+=1
)
popd

echo %green%Added %added_dirs% model directories to configuration.%reset%
call :show_current_config
echo.
echo %yellow%Press any key to continue...%reset%
pause >nul
exit /b 0

:show_current_config
cls
call :check_comfyui_set
if errorlevel 1 goto :main_menu

if exist "%yaml%" (
    echo %green%Current extra_model_paths.yaml configuration:%reset%
    echo ==============================================
    type "%yaml%"
    echo ==============================================
) else (
    echo %yellow%No configuration file found.%reset%
)
echo.
echo %yellow%Press any key to continue...%reset%
pause >nul
goto :main_menu

:remove_config
cls
call :check_comfyui_set
if errorlevel 1 goto :main_menu

if exist "%yaml%" (
    echo %yellow%Current configuration file: %yaml%%reset%
    echo.
    set /p "confirm=Are you sure you want to remove the current configuration? (y/n): "
    if /i "!confirm!"=="y" (
        del "%yaml%"
        echo %green%Configuration removed.%reset%
    ) else (
        echo %yellow%Configuration removal cancelled.%reset%
    )
) else (
    echo %yellow%No configuration file to remove.%reset%
)
echo.
echo %yellow%Press any key to continue...%reset%
pause >nul
goto :main_menu

:exit_script
echo %green%Goodbye!%reset%
exit /b 0
