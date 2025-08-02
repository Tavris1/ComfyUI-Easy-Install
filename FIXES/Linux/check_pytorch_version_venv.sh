#!/bin/bash

# Script to check PyTorch version and SDPA support in a virtual environment
echo "Checking PyTorch version and SDPA support..."

# Define the virtual environment path
VENV_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/venv"
COMFYUI_PATH="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI"

# Check if the virtual environment exists
if [ ! -d "$VENV_PATH" ]; then
    echo "Error: Virtual environment not found at $VENV_PATH"
    echo "Please update the script with the correct path to your virtual environment."
    exit 1
fi

# Activate the virtual environment and run Python check
echo "Using virtual environment at: $VENV_PATH"
if [ -f "$VENV_PATH/bin/activate" ]; then
    # Create a temporary Python script to check PyTorch
    cat > /tmp/check_pytorch.py << 'EOF'
import sys

# Function to check if a package is installed
def is_package_installed(package_name):
    try:
        __import__(package_name)
        return True
    except ImportError:
        return False

# Check if PyTorch is installed
if not is_package_installed("torch"):
    print("PyTorch is not installed.")
    print("You need to install PyTorch to use Sage attention.")
    sys.exit(0)

# Check PyTorch version and SDPA support
import torch
import torch.nn.functional as F

print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"Current CUDA device: {torch.cuda.current_device()}")
    print(f"Current CUDA device name: {torch.cuda.get_device_name(torch.cuda.current_device())}")

# Check for SDPA support
has_sdpa = hasattr(torch.nn.functional, 'scaled_dot_product_attention')
print(f"SDPA support available: {has_sdpa}")

# Check if PyTorch version is sufficient for SDPA
version_parts = torch.__version__.split('.')
major_version = int(version_parts[0])
minor_version = int(version_parts[1])

if major_version < 2:
    print("\nYour PyTorch version is too old for native SDPA support.")
    print("SDPA requires PyTorch 2.0.0 or newer.")
    print("Recommended action: Update PyTorch to version 2.0.0 or newer.")
elif not has_sdpa:
    print("\nYour PyTorch version should support SDPA, but the function is not available.")
    print("This might be due to a custom build or other configuration issue.")
else:
    print("\nYour PyTorch version supports SDPA!")
    print("ComfyUI should be able to use Sage attention if properly configured.")

# Check if xformers is installed (alternative attention implementation)
has_xformers = is_package_installed("xformers")
print(f"\nxformers installed: {has_xformers}")
if has_xformers:
    import xformers
    print(f"xformers version: {xformers.__version__}")
    print("Note: xformers provides an alternative efficient attention implementation")
    print("      that might be used instead of or alongside SDPA.")

# Check ComfyUI model_management for attention settings
try:
    import sys
    comfyui_path = "/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install/ComfyUI"
    if comfyui_path not in sys.path:
        sys.path.append(comfyui_path)
    
    from comfy import model_management
    
    print("\nComfyUI model_management attention settings:")
    if hasattr(model_management, "get_torch_device"):
        device = model_management.get_torch_device()
        print(f"Torch device: {device}")
    
    # Try to access attention settings
    attention_settings = {}
    for attr in dir(model_management):
        if "attention" in attr.lower() or "sdpa" in attr.lower():
            try:
                value = getattr(model_management, attr)
                attention_settings[attr] = value
            except:
                pass
    
    if attention_settings:
        print("Found attention-related settings:")
        for key, value in attention_settings.items():
            print(f"  {key}: {value}")
    else:
        print("No specific attention settings found in model_management.")
        
except Exception as e:
    print(f"\nCould not check ComfyUI model_management: {e}")
EOF

    # Run the Python script with the virtual environment's Python
    echo "Running Python check with virtual environment..."
    source "$VENV_PATH/bin/activate"
    python /tmp/check_pytorch.py
    deactivate
else
    echo "Error: Could not find activation script in the virtual environment."
    echo "Make sure this is a valid Python virtual environment."
    exit 1
fi

# Clean up
rm /tmp/check_pytorch.py

echo "Check completed."
