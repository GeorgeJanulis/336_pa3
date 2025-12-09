# download_model.py

from huggingface_hub import hf_hub_download
import sys
import os

REPO_ID = "Qwen/Qwen2.5-3B-Instruct-GGUF"
FILENAME = "qwen2.5-3b-instruct-q5_k_m.gguf"

print(f"Attempting to download {FILENAME} from {REPO_ID}...")

try:
    # Use hf_hub_download to fetch the file. It will save it to the Hugging Face cache.
    # We use local_dir to ensure it goes into a known location (the current directory)
    model_path = hf_hub_download(
        repo_id=REPO_ID,
        filename=FILENAME,
        local_dir=".", # Download it to the current directory
        local_dir_use_symlinks=False
    )
    print("\n---------------------------------------------------------")
    print(f"✅ Download successful! The model is saved at: {model_path}")
    print("---------------------------------------------------------")
    
except Exception as e:
    print(f"\n❌ ERROR during download: {e}")
    print("Please ensure your internet connection is stable and the repository/file name is correct.")
    sys.exit(1)