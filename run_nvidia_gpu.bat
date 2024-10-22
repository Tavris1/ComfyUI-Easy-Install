@Echo off
setx NO_ALBUMENTATIONS_UPDATE 1
.\python_embeded\python.exe -s ComfyUI\main.py --windows-standalone-build --disable-smart-memory --fast
pause
