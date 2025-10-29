@echo off
REM ComfyUI Backup Script for Windows
REM Pixaroma Community Edition
REM by ivo
REM Creates timestamped backups of ComfyUI input, output, and user directories

setlocal enabledelayedexpansion

REM Colors for output (using ANSI escape codes if supported, otherwise plain text)
REM Note: Windows 10+ supports ANSI in some terminals, but for compatibility, we'll use plain text

REM Default paths
set "COMFY_DIR=%USERPROFILE%\ComfyUI-Easy-Install\ComfyUI"
set "BACKUP_DIR=%COMFY_DIR%\user_backups"
set "USER_DIR=%COMFY_DIR%\user"
set "INPUT_DIR=%COMFY_DIR%\input"
set "OUTPUT_DIR=%COMFY_DIR%\output"

REM Generate timestamp
for /f "tokens=1-6 delims= " %%a in ("%date% %time%") do (
    set "TIMESTAMP=%%c%%a%%b_%%d%%e%%f"
    set "TIMESTAMP=!TIMESTAMP: =0!"
)

set "BACKUP_NAME=comfyui_backup_!TIMESTAMP!"

REM Check if user directory exists
if not exist "%USER_DIR%" (
    echo Error: User directory not found at %USER_DIR%
    pause
    exit /b 1
)

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if errorlevel 1 (
    echo Error: Failed to create backup directory %BACKUP_DIR%
    pause
    exit /b 1
)

REM Create the backup
echo Creating backup of ComfyUI directories...
mkdir "%BACKUP_DIR%\%BACKUP_NAME%"

REM Backup user directory
if exist "%USER_DIR%" (
    robocopy "%USER_DIR%" "%BACKUP_DIR%\%BACKUP_NAME%\user" /E /PURGE /XD __pycache__ .git /XF *.tmp *.bak *.swp >nul 2>&1
)

REM Backup input directory
if exist "%INPUT_DIR%" (
    robocopy "%INPUT_DIR%" "%BACKUP_DIR%\%BACKUP_NAME%\input" /E /PURGE /XD __pycache__ .git /XF *.tmp *.bak *.swp >nul 2>&1
)

REM Backup output directory
if exist "%OUTPUT_DIR%" (
    robocopy "%OUTPUT_DIR%" "%BACKUP_DIR%\%BACKUP_NAME%\output" /E /PURGE /XD __pycache__ .git /XF *.tmp *.bak *.swp >nul 2>&1
)

REM Check if backup was successful
if not errorlevel 1 (
    REM Create a symlink to the latest backup (using mklink)
    rmdir /Q "%BACKUP_DIR%\latest" 2>nul
    mklink /D "%BACKUP_DIR%\latest" "%BACKUP_DIR%\%BACKUP_NAME%" >nul 2>&1
    
    REM Clean up old backups (keep last 10)
    echo Cleaning up old backups...
    for /f "skip=10 delims=" %%i in ('dir /b /o-d "%BACKUP_DIR%\comfyui_backup_*" 2^>nul') do (
        rmdir /S /Q "%BACKUP_DIR%\%%i"
    )
    
    REM Show backup info
    for /f "tokens=*" %%i in ('dir /b "%BACKUP_DIR%\%BACKUP_NAME%" 2^>nul ^| find /c /v ""') do set "FILE_COUNT=%%i"
    echo.
    echo Backup completed successfully!
    echo Backup location: %BACKUP_DIR%\%BACKUP_NAME%
    echo Files backed up: !FILE_COUNT!
    echo Latest backup: %BACKUP_NAME%
) else (
    echo Error: Backup failed
    pause
    exit /b 1
)

REM Create a restore script
(
echo @echo off
echo REM Script to restore the latest ComfyUI backup
echo.
echo set "BACKUP_DIR=%%~dp0"
echo set "LATEST_BACKUP=%%BACKUP_DIR%%latest"
echo set "TARGET_DIR=%%~dp0.."
echo.
echo if not exist "%%LATEST_BACKUP%%" (
echo     echo Error: No backup found to restore
echo     pause
echo     exit /b 1
echo )
echo.
echo echo Restoring ComfyUI directories from latest backup...
echo if exist "%%LATEST_BACKUP%%\user" (
echo     robocopy "%%LATEST_BACKUP%%\user" "%%TARGET_DIR%%\user" /E /PURGE
echo )
echo if exist "%%LATEST_BACKUP%%\input" (
echo     robocopy "%%LATEST_BACKUP%%\input" "%%TARGET_DIR%%\input" /E /PURGE
echo )
echo if exist "%%LATEST_BACKUP%%\output" (
echo     robocopy "%%LATEST_BACKUP%%\output" "%%TARGET_DIR%%\output" /E /PURGE
echo )
echo.
echo if not errorlevel 1 (
echo     echo Restore completed successfully!
echo ) else (
echo     echo Error: Restore failed
echo     pause
echo     exit /b 1
echo )
) > "%BACKUP_DIR%\restore_latest.bat"

echo.
echo Restore script created: %BACKUP_DIR%\restore_latest.bat

pause
endlocal
