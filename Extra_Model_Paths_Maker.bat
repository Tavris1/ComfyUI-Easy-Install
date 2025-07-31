@Echo off
Title Extra Model Paths Maker by ivo v0.55.3
:: Pixaroma Community Edition ::

set "yaml=extra_model_paths.yaml"

cd /d %~dp0

if not exist checkpoints (
	Echo.
	Echo [33mWARNING:[0m [92mPlace this file in shared 'models' folder and run it again.[0m
	Echo.
	Echo Press any key to Exit...&Pause>nul
	goto :eof
)

set "modelsfolder=%~dp0"

for /f "delims=" %%A in ('cd') do set "modelsname=%%~nxA"

Echo comfyui:>%yaml%
cd ..\
Echo     base_path: %cd%\>>"%modelsfolder%%yaml%"
cd %modelsfolder%
Echo     is_default: true>>%yaml%
Echo.>>%yaml%
for /D %%f in (*) do echo     %%f: %modelsname%\%%f\>>%yaml%
start notepad %yaml%
