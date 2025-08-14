#!/bin/bash
# ComfyUI Update Script for LXC Container with PyTorch 2.8.0 Preservation
# Designed specifically for Proxmox LXC container environment
# Preserves PyTorch 2.8.0 installation while updating ComfyUI

# Set colors for better readability
green="\033[92m"
yellow="\033[93m"
red="\033[91m"
reset="\033[0m"

echo -e "${green}::::::::::::::: ComfyUI LXC Update (PyTorch 2.8.0 Safe) :::::::::::::::${reset}"
echo

# Define paths for the LXC container environment
SCRIPT_DIR="/root/ComfyUI-Easy-Install/ComfyUI-Easy-Install"
VENV_PATH="$SCRIPT_DIR/venv"
COMFYUI_DIR="$SCRIPT_DIR/ComfyUI"
UPDATE_DIR="$SCRIPT_DIR/update"

# Check if ComfyUI directory exists
if [ ! -d "$COMFYUI_DIR" ]; then
    echo -e "${red}Error: ComfyUI directory not found at $COMFYUI_DIR${reset}"
    echo "Please check the path and try again."
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "$VENV_PATH" ]; then
    echo -e "${red}Error: Virtual environment not found at $VENV_PATH${reset}"
    echo "Please check the path and try again."
    exit 1
fi

# Activate virtual environment and save current PyTorch version
echo -e "${yellow}Activating virtual environment and checking PyTorch version...${reset}"
source "$VENV_PATH/bin/activate"

# Check if PyTorch is installed
if ! python -c "import torch" &>/dev/null; then
    echo -e "${red}PyTorch is not installed in the virtual environment.${reset}"
    echo "Please install PyTorch first using the install_pytorch_2.8.0_direct.sh script."
    deactivate
    exit 1
fi

# Save current PyTorch version and CUDA status
CURRENT_TORCH_VERSION=$(python -c "import torch; print(torch.__version__)" 2>/dev/null)
CUDA_AVAILABLE=$(python -c "import torch; print(torch.cuda.is_available())" 2>/dev/null)
SDPA_AVAILABLE=$(python -c "import torch; print(hasattr(torch.nn.functional, 'scaled_dot_product_attention'))" 2>/dev/null)

echo -e "${green}Current PyTorch version: $CURRENT_TORCH_VERSION${reset}"
echo -e "${green}CUDA available: $CUDA_AVAILABLE${reset}"
echo -e "${green}SDPA available: $SDPA_AVAILABLE${reset}"

# Install pygit2 if not already installed
echo -e "${yellow}Checking for pygit2...${reset}"
if ! python -c "import pygit2" &>/dev/null; then
    echo -e "${yellow}Installing pygit2...${reset}"
    pip install pygit2
fi

# Create update directory if it doesn't exist
mkdir -p "$UPDATE_DIR"
cd "$UPDATE_DIR" || exit 1

# Create update.py directly in the script
echo -e "${yellow}Creating update.py script...${reset}"
cat > update.py << 'EOF'
import pygit2
from datetime import datetime
import sys
import os
import shutil
import filecmp

def pull(repo, remote_name='origin', branch='master'):
    for remote in repo.remotes:
        if remote.name == remote_name:
            remote.fetch()
            remote_master_id = repo.lookup_reference('refs/remotes/origin/%s' % (branch)).target
            merge_result, _ = repo.merge_analysis(remote_master_id)
            # Up to date, do nothing
            if merge_result & pygit2.GIT_MERGE_ANALYSIS_UP_TO_DATE:
                return
            # We can just fastforward
            elif merge_result & pygit2.GIT_MERGE_ANALYSIS_FASTFORWARD:
                repo.checkout_tree(repo.get(remote_master_id))
                try:
                    master_ref = repo.lookup_reference('refs/heads/%s' % (branch))
                    master_ref.set_target(remote_master_id)
                except KeyError:
                    repo.create_branch(branch, repo.get(remote_master_id))
                repo.head.set_target(remote_master_id)
            elif merge_result & pygit2.GIT_MERGE_ANALYSIS_NORMAL:
                repo.merge(remote_master_id)

                if repo.index.conflicts is not None:
                    for conflict in repo.index.conflicts:
                        print('Conflicts found in:', conflict[0].path)
                    raise AssertionError('Conflicts, ahhhhh!!')

                user = repo.default_signature
                tree = repo.index.write_tree()
                repo.create_commit('HEAD',
                                    user,
                                    user,
                                    'Merge!',
                                    tree,
                                    [repo.head.target, remote_master_id])
                # We need to do this or git CLI will think we are still merging.
                repo.state_cleanup()
            else:
                raise AssertionError('Unknown merge analysis result')

pygit2.option(pygit2.GIT_OPT_SET_OWNER_VALIDATION, 0)
repo_path = str(sys.argv[1])
repo = pygit2.Repository(repo_path)
ident = pygit2.Signature('comfyui', 'comfy@ui')
try:
    print("stashing current changes")
    repo.stash(ident)
except KeyError:
    print("nothing to stash")
backup_branch_name = 'backup_branch_{}'.format(datetime.today().strftime('%Y-%m-%d_%H_%M_%S'))
print("creating backup branch: {}".format(backup_branch_name))
try:
    repo.branches.local.create(backup_branch_name, repo.head.peel())
except:
    pass

print("checking out master branch")
branch = repo.lookup_branch('master')
if branch is None:
    ref = repo.lookup_reference('refs/remotes/origin/master')
    repo.checkout(ref)
    branch = repo.lookup_branch('master')
    if branch is None:
        repo.create_branch('master', repo.get(ref.target))
else:
    ref = repo.lookup_reference(branch.name)
    repo.checkout(ref)

print("pulling latest changes")
pull(repo)

if "--stable" in sys.argv:
    def latest_tag(repo):
        versions = []
        for k in repo.references:
            try:
                prefix = "refs/tags/v"
                if k.startswith(prefix):
                    version = list(map(int, k[len(prefix):].split(".")))
                    versions.append((version[0] * 10000000000 + version[1] * 100000 + version[2], k))
            except:
                pass
        versions.sort()
        if len(versions) > 0:
            return versions[-1][1]
        return None
    latest_tag = latest_tag(repo)
    if latest_tag is not None:
        repo.checkout(latest_tag)

print("Done!")

self_update = True
if len(sys.argv) > 2:
    self_update = '--skip_self_update' not in sys.argv

update_py_path = os.path.realpath(__file__)
repo_update_py_path = os.path.join(repo_path, ".ci/update_windows/update.py")

cur_path = os.path.dirname(update_py_path)

req_path = os.path.join(cur_path, "current_requirements.txt")
repo_req_path = os.path.join(repo_path, "requirements.txt")

def files_equal(file1, file2):
    try:
        return filecmp.cmp(file1, file2, shallow=False)
    except:
        return False

def file_size(f):
    try:
        return os.path.getsize(f)
    except:
        return 0

if self_update and not files_equal(update_py_path, repo_update_py_path) and file_size(repo_update_py_path) > 10:
    shutil.copy(repo_update_py_path, os.path.join(cur_path, "update_new.py"))
    exit()

if not os.path.exists(req_path) or not files_equal(repo_req_path, req_path):
    import subprocess
    try:
        subprocess.check_call([sys.executable, '-s', '-m', 'pip', 'install', '-r', repo_req_path])
        shutil.copy(repo_req_path, req_path)
    except:
        pass
EOF

# Run the Python update script
echo -e "${yellow}Updating ComfyUI...${reset}"
if ! python update.py "$COMFYUI_DIR/"; then
    echo -e "${red}Error: Failed to update ComfyUI${reset}"
    deactivate
    exit 1
fi

# Check if the updater itself was updated
if [ -f "update_new.py" ]; then
    mv -f update_new.py update.py
    echo -e "${yellow}Running updater again since it got updated.${reset}"
    if ! python update.py "$COMFYUI_DIR/" --skip_self_update; then
        echo -e "${red}Error: Failed to run updated updater${reset}"
        deactivate
        exit 1
    fi
fi

# Install requirements but exclude torch, torchvision, and torchaudio
echo -e "${yellow}Installing requirements (excluding PyTorch packages)...${reset}"
grep -v "torch\|torchvision\|torchaudio" "$COMFYUI_DIR/requirements.txt" > "$UPDATE_DIR/filtered_requirements.txt"
pip install -r "$UPDATE_DIR/filtered_requirements.txt"

# Check if PyTorch version changed and restore if needed
NEW_TORCH_VERSION=$(python -c "import torch; print(torch.__version__)" 2>/dev/null)
if [[ "$NEW_TORCH_VERSION" != "$CURRENT_TORCH_VERSION" && "$CURRENT_TORCH_VERSION" == *"2.8.0"* ]]; then
    echo -e "${yellow}PyTorch version changed from $CURRENT_TORCH_VERSION to $NEW_TORCH_VERSION${reset}"
    echo -e "${yellow}Restoring PyTorch 2.8.0...${reset}"
    
    # Uninstall current PyTorch
    pip uninstall -y torch torchvision torchaudio
    
    # Reinstall PyTorch 2.8.0
    echo -e "${yellow}Reinstalling PyTorch 2.8.0 with CUDA support...${reset}"
    pip install torch==2.8.0+cu128 torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu128
    
    # Verify installation
    RESTORED_VERSION=$(python -c "import torch; print(torch.__version__)" 2>/dev/null)
    RESTORED_CUDA=$(python -c "import torch; print(torch.cuda.is_available())" 2>/dev/null)
    RESTORED_SDPA=$(python -c "import torch; print(hasattr(torch.nn.functional, 'scaled_dot_product_attention'))" 2>/dev/null)
    
    echo -e "${green}Restored PyTorch version: $RESTORED_VERSION${reset}"
    echo -e "${green}CUDA available: $RESTORED_CUDA${reset}"
    echo -e "${green}SDPA available: $RESTORED_SDPA${reset}"
else
    echo -e "${green}PyTorch version unchanged: $CURRENT_TORCH_VERSION${reset}"
fi

# Check for Nunchaku and reinstall if needed
if [ -d "$COMFYUI_DIR/custom_nodes/ComfyUI-nunchaku" ]; then
    echo -e "${yellow}Checking Nunchaku installation...${reset}"
    
    # Try to import nunchaku
    if ! python -c "import nunchaku" &>/dev/null; then
        echo -e "${yellow}Reinstalling Nunchaku...${reset}"
        cd "$COMFYUI_DIR/custom_nodes/ComfyUI-nunchaku" || exit 1
        pip install -e .
        echo -e "${green}Nunchaku reinstalled${reset}"
    else
        echo -e "${green}Nunchaku is properly installed${reset}"
    fi
fi

# Check for SageAttention and reinstall if needed
if python -c "import sageattention" &>/dev/null; then
    SAGE_VERSION=$(python -c "import sageattention; print(getattr(sageattention, '__version__', 'unknown'))" 2>/dev/null)
    echo -e "${green}SageAttention is installed (version: $SAGE_VERSION)${reset}"
else
    echo -e "${yellow}SageAttention not found. You may want to reinstall it using install_sage_triton_stable.sh${reset}"
fi

# Deactivate virtual environment
deactivate

echo -e "\n${green}ComfyUI update completed successfully!${reset}"
echo -e "${green}PyTorch version preserved: $CURRENT_TORCH_VERSION${reset}"
echo "You can now start ComfyUI using:"
echo "cd $SCRIPT_DIR && ./run_comfyui_fp16fast_sage.sh"
