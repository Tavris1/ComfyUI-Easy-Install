#!/bin/bash

echo
echo "V4.4 Automatic PyTorch 2.8.0 Stable, Triton and Sage 2 installation script for Linux"
echo "This script will install PyTorch 2.8.0 Stable with CUDA 12.8 support."
echo "NB: If you want to use FastFP16 (extra ~10 percent), you will need CUDA 12.6 or 12.8 installed."
echo "NB: Sage2 will work on its own with PyTorch 2.8.0 with CUDA 12.8."
echo
read -p "Press Enter to continue..."

# Path to ComfyUI installation
COMFYUI_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI"
VENV_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/venv"

# Check if ComfyUI's custom_nodes folder exists
if [ ! -d "$COMFYUI_PATH/custom_nodes" ]; then
    echo "Custom nodes folder not found at $COMFYUI_PATH/custom_nodes"
    read -p "Press Enter to continue anyway..."
fi

# Check for any custom nodes excluding _pycache_, example_node.py.example, and websocket_image_save.py
CUSTOM_NODES_PATH="$COMFYUI_PATH/custom_nodes"
if [ -d "$CUSTOM_NODES_PATH" ]; then
    FOUND_CUSTOM_NODES=false
    
    for file in "$CUSTOM_NODES_PATH"/*; do
        basename=$(basename "$file")
        if [ "$basename" != "__pycache__" ] && [ "$basename" != "example_node.py.example" ] && [ "$basename" != "websocket_image_save.py" ]; then
            FOUND_CUSTOM_NODES=true
            break
        fi
    done
    
    # If any other files or node folders are found, ask for confirmation
    if [ "$FOUND_CUSTOM_NODES" = true ]; then
        echo
        echo "Detected custom nodes in $CUSTOM_NODES_PATH"
        echo "This script is intended for new installs, but can be used for updates as well."
        read -p "Do you want to continue? (y/n): " CONTINUE
        if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
            echo "Installation aborted."
            exit 1
        fi
    fi
fi

# Using CUDA 12.8 for PyTorch 2.8.0 stable
CUDA_VERSION="12.8"
CLEAN_CUDA="128"

echo "Using CUDA Version: $CUDA_VERSION for PyTorch installation"
echo
read -p "Press Enter to continue..."

# Activate virtual environment
echo "Activating virtual environment..."
source "$VENV_PATH/bin/activate"

# Install PyTorch with system CUDA
echo "Uninstalling existing PyTorch packages..."
pip uninstall -y torch torchvision torchaudio

echo "Installing PyTorch 2.8.0 stable with CUDA $CUDA_VERSION..."
pip install torch==2.8.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128

echo "Installing specific setuptools version..."
pip install "setuptools == 70.2.0"
echo
echo "Installed older version of Setuptools, as some permutations of installs with"
echo "newer Setuptools will stop installation of Sage (setuptools v70.2.0 installed)"
echo
read -p "Press Enter to continue..."

# Create update script
UPDATE_SCRIPT_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/update_comfyui_and_python_dependencies.sh"
echo "Creating update script at $UPDATE_SCRIPT_PATH..."

cat > "$UPDATE_SCRIPT_PATH" << EOF
#!/bin/bash
# Update ComfyUI and Python dependencies
cd /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install
source venv/bin/activate
cd ComfyUI
git pull
cd ..
pip install --upgrade torch==2.8.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128 -r ComfyUI/requirements.txt pygit2
EOF

chmod +x "$UPDATE_SCRIPT_PATH"

if [ -f "$UPDATE_SCRIPT_PATH" ]; then
    echo "The file $UPDATE_SCRIPT_PATH has been created successfully."
else
    echo "Failed to create the file $UPDATE_SCRIPT_PATH."
fi

# Install Triton
echo
echo "Choose which version of Triton to install (Nightly might help with newer GPUs):"
echo "[1] Nightly"
echo "[2] Stable"
read -p "Enter your choice (1/2): " TRITON_CHOICE

if [ "$TRITON_CHOICE" = "1" ]; then
    echo "Installing latest Nightly Triton version..."
    pip install -U --pre triton
elif [ "$TRITON_CHOICE" = "2" ]; then
    echo "Installing latest Stable Triton version..."
    pip install triton
else
    echo "Invalid choice. Skipping Triton installation."
fi

read -p "Press Enter to continue..."

# Install SageAttention
echo "Choose which version of SageAttention to install:"
echo
echo "[1] SageAttention v1"
echo "[2] SageAttention v2"
read -p "Enter your choice (1 or 2): " SAGE_CHOICE

if [ "$SAGE_CHOICE" = "1" ]; then
    echo "Installing SageAttention v1..."
    pip install sageattention==1.0.6
    echo "Successfully installed SageAttention v1."
    echo
    read -p "Press Enter to continue..."
elif [ "$SAGE_CHOICE" = "2" ]; then
    echo "Installing SageAttention v2..."
    cd /tmp
    git clone https://github.com/thu-ml/SageAttention
    cd SageAttention
    export MAX_JOBS=4
    pip install .
    cd ..
    rm -rf SageAttention
    echo "Successfully installed SageAttention v2 and cleaned up."
    echo
    read -p "Press Enter to continue..."
else
    echo "Invalid choice. Installation aborted."
    exit 1
fi

# Create run script with SageAttention
RUN_SCRIPT_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/run_comfyui_fp16fast_sage.sh"
echo "Creating run script with SageAttention at $RUN_SCRIPT_PATH..."

cat > "$RUN_SCRIPT_PATH" << EOF
#!/bin/bash
cd /root/ComfyUI-Easy-Install/ComfyUI-Easy-Install
source venv/bin/activate
python ComfyUI/main.py --use-sage-attention --fast fp16_accumulation --listen 0.0.0.0
EOF

chmod +x "$RUN_SCRIPT_PATH"

if [ -f "$RUN_SCRIPT_PATH" ]; then
    echo "The file $RUN_SCRIPT_PATH has been created successfully."
else
    echo "Failed to create the file $RUN_SCRIPT_PATH."
fi

# Install ComfyUI Manager
echo
echo "Installing ComfyUI Manager..."
cd "$COMFYUI_PATH/custom_nodes"
if [ -d "ComfyUI-Manager" ]; then
    echo "ComfyUI-Manager already exists. Updating..."
    cd ComfyUI-Manager
    git pull
    cd ..
else
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git
    echo "Successfully cloned ComfyUI-Manager"
fi

echo
echo "Installation complete!"
echo "You can now run ComfyUI with SageAttention using: $RUN_SCRIPT_PATH"
echo "Or update ComfyUI and dependencies using: $UPDATE_SCRIPT_PATH"
echo

# Deactivate virtual environment
deactivate

read -p "Press Enter to exit..."
