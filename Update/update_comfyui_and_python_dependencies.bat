@echo off
call update_comfyui.bat nopause
echo -
echo This will try to update pytorch and all python dependencies.
echo -
echo If you just want to update normally, close this and run update_comfyui.bat instead.
echo -
pause
..\python_embeded\python.exe -s -m pip install --upgrade torch torchvision torchaudio  --extra-index-url https://download.pytorch.org/whl/cu128 -r ../ComfyUI/requirements.txt pygit2
pause
