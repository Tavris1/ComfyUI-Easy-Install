@Echo off
Title ComfyUI Folder Links by ivo 2024.10.12

CD /D "%~dp0"

:: set colors ::
call :set_colors

if exist ComfyUI_windows_portable\ComfyUI (cd ComfyUI_windows_portable)
if exist ComfyUI\comfy (cd ComfyUI) else (
	Echo.
	Echo %warning%WARNING:%reset% '%bold%ComfyUI%reset%' folder not exists!
	Echo.
	Echo Press any key to exit...&Pause>nul
	GOTO :eof
)

:: RunAsAdmin ::
if not "%1"=="am_admin" (Echo %green%::::::::::::: Request to Run as Admin.. :::::::::::::%reset%)
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

:: Creating Folder links ::
Echo %green%::::::::::::: Creating Folder links :::::::::::::%reset%

:: Settings ::
set base_folder="C:\AI"

call :make_folder_link models
call :make_folder_link input
call :make_folder_link output
call :make_folder_link user
:: END Settings ::

cd ..\
Echo %green%::::::::::::: Done! %reset%Exiting&TimeOut 3
goto :eof

:make_folder_link
set source_folder=%~1
if exist .\%source_folder% rd /s /q .\%source_folder%
mklink /J ".\%source_folder%" "%base_folder%\%source_folder%"
goto :eof

:set_colors
set warning=[33m
set   green=[92m
set    bold=[1m
set   reset=[0m
goto :eof