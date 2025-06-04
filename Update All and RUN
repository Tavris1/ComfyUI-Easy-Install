@Echo off
Title ComfyUI-Update All and RUN by ivo
:: Pixaroma Community Edition ::
:: Updates ComfyUI and its nodes and starts it

Echo [92m::::::::::::::: Updating ComfyUI :::::::::::::::[0m
Echo.
cd .\update&&call .\update_comfyui.bat nopause&&cd ..\
Echo.

Echo [92m::::::::::::::: Updating All Nodes :::::::::::::::[0m
Echo.
.\python_embeded\python.exe ComfyUI\custom_nodes\ComfyUI-Manager\cm-cli.py update all
Echo.
Echo [92m::::::::::::::: Done. Starting ComfyUI :::::::::::::::[0m
Echo.

call run_nvidia_gpu.bat