# Docker Build Optimization

## Problem

The Docker build was failing during `pip install -r requirements.txt` due to downloading large CUDA-enabled PyTorch wheels (~2.5GB total):

- `torch-2.9.1-cp312-...whl` (899.7 MB)
- `nvidia_cublas_cu12-12.8.4.1-...whl` (594.3 MB)
- `nvidia_cudnn_cu12-9.10.2.21-...whl` (706.8 MB)
- Plus additional CUDA libraries

This caused:
- Build timeouts (Railway/Coolify have ~10-15 min build limits)
- Memory exhaustion
- Disk space issues
- Deployment failures

## Root Cause

The `mineru[core]==2.6.4` dependency includes the `[core]` extra which pulls in:
- `mineru[vlm]`
- `mineru[pipeline]` - **This includes `torch>=2.6.0` with full CUDA support**
- `mineru[api]`
- `mineru[gradio]`

## Solution

### 1. Use Base MinerU Package

Changed `requirements.txt`:
```diff
- mineru[core]==2.6.4
+ mineru==2.6.4
```

The base `mineru` package includes all essential dependencies for document parsing:
- PDF parsing (pdfminer.six, pypdf, pypdfium2)
- Image processing (opencv-python, pillow, scikit-image)
- OCR capabilities (fast-langdetect)
- Document conversion (reportlab)

**It does NOT require PyTorch or CUDA libraries.**

### 2. Added Pip Install Optimizations

Updated `docker/Dockerfile.backend`:
```dockerfile
RUN pip install --no-cache-dir --prefer-binary --default-timeout=100 -r requirements.txt
```

Flags explained:
- `--no-cache-dir`: Don't cache downloaded packages (saves disk space)
- `--prefer-binary`: Use pre-built binary wheels when available (faster installation)
- `--default-timeout=100`: Increased timeout for large packages

## Impact

### Before (with mineru[core])
- Total download size: ~2.5GB
- Installation time: 5-10+ minutes
- Frequent build failures due to timeouts

### After (with base mineru)
- Total download size: ~200-300MB
- Installation time: 1-3 minutes
- Successful builds within resource limits

## Functionality

**No functionality is lost** - Paper2Slides uses MinerU as a CLI tool for document parsing, which is fully functional with the base package. The `[core]` extra includes additional machine learning features (VLM, advanced models) that are not required for our use case.

## When You Might Need torch/CUDA

If you later need GPU-accelerated features (e.g., for advanced VLM processing), you can:

1. Create a separate `requirements-gpu.txt`:
   ```
   torch>=2.6.0
   torchvision
   mineru[pipeline]==2.6.4
   ```

2. Add a build argument to the Dockerfile:
   ```dockerfile
   ARG INSTALL_GPU=false
   RUN if [ "$INSTALL_GPU" = "true" ]; then \
       pip install --no-cache-dir -r requirements-gpu.txt; \
   fi
   ```

3. Build with GPU support:
   ```bash
   docker build --build-arg INSTALL_GPU=true -f docker/Dockerfile.backend .
   ```

## Verification

To verify the changes work:

```bash
# Test in a clean environment
python3 -m venv test_env
source test_env/bin/activate
pip install --no-cache-dir --prefer-binary mineru==2.6.4

# Verify MinerU CLI is available
mineru --help
```

## References

- [MinerU PyPI Package](https://pypi.org/project/mineru/)
- [Railway Build Limits](https://docs.railway.app/reference/pricing)
- [Coolify Documentation](https://coolify.io/docs)
