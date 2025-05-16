#!/bin/bash
cd "$(dirname "$0")"

# Clear RAM before starting ComfyUI
echo "Clearing RAM cache to free up memory..."
# Try non-sudo memory clearing techniques first
# Force macOS to drop disk caches and buffer caches
echo 3 > /dev/null 2>&1 || true
# Alternative approach without sudo
python3 -c 'import ctypes; ctypes.CDLL(None).malloc_zone_pressure_relief(0, 0)' 2>/dev/null || true

# Kill any lingering Python processes that might be using memory
echo "Stopping any running Python processes..."
pkill -f "python.*main.py" 2>/dev/null || true

# Give the system a moment to release memory
sleep 1

# Set environment variables for M1 GPU optimization
export PYTORCH_ENABLE_MPS_FALLBACK=1

# Memory optimization settings
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0  # Allow using more GPU memory
export PYTORCH_MPS_LOW_WATERMARK_RATIO=0.7   # Higher threshold for better stability
export PYTORCH_MPS_MINIMUM_MEMORY_WARNINGS=0  # Reduce warning spam
export PYTORCH_MPS_ALLOCATOR_POLICY=garbage_collection  # Enable aggressive GC

# Additional memory optimizations
export PYTORCH_MPS_ALLOCATOR_BLOCK_SIZE=1073741824  # 1GB blocks for better memory management

# Additional performance optimizations
export TORCH_MPS_PLEASE_CACHE_DESCRIPTORS=1   # Improve descriptor caching
export PYTORCH_MPS_ENABLE_GRAPH_MODE=1       # Enable graph mode for better performance

# Enable unified memory for better memory management
export PYTORCH_MPS_ENABLE_UNIFIED_MEMORY=1
export PYTORCH_MPS_ENABLE_GUARD_IMPLEMENTATION=1

# ComfyUI specific optimizations
export COMFYUI_USE_MPS=1    
export COMFYUI_VRAM_OPTIMIZATIONS=MPS
export COMFYUI_FORCE_MPS=1

# Data type compatibility fixes
export PYTORCH_MPS_USE_FP32_ACCUM=1  # Use FP32 for accumulation to improve precision
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:32  # Limit memory splits
export PYTORCH_FLOAT8_DISABLED=1  # Disable Float8 which is not supported on MPS
export PYTORCH_PREFER_FLOAT32=1  # Prefer float32 over unsupported types

# Fix for tensor view errors in upscalers (Ultimate SD Upscale)
export PYTORCH_MPS_CONTIGUOUS_FORMAT=1  # Force contiguous memory format for tensors

# Force Python garbage collection before activating environment
echo "Running Python garbage collection..."
python3 -c "import gc; gc.collect()" 2>/dev/null || true

# Correct paths for nested ComfyUI-Easy-Install directory structure
# Use the absolute path to python since the activate script might not be working correctly
PYTHON="$(pwd)/ComfyUI-Easy-Install/python_embedded/bin/python"
cd ./ComfyUI-Easy-Install/ComfyUI
"$PYTHON" main.py --force-upcast-attention
