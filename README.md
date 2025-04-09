# CUDA-Enabled PyTorch 🔥 Build on Jetson AGX Orin (Python 3.10)

This guide documents how to build and install PyTorch **from source** with **CUDA acceleration** on **NVIDIA Jetson AGX Orin**, targeting Python 3.10. This setup includes CUDA 11.4 support and was tested in a clean environment.

> **Note**: Using a **Python virtual environment is optional**, but recommended to isolate dependencies.

---

## System Info

- Device: Jetson AGX Orin
- OS: Ubuntu 20.04
- Python: 3.10.16 (venv)
- CUDA: 11.4
- CMake: ≥3.25 required

---

## Optional: Create a Virtual Environment

```bash
python3.10 -m venv ~/venvs/RAG_3_10
source ~/venvs/RAG_3_10/bin/activate
```

## Install Required Python Packages

```bash
pip install --upgrade pip
pip install numpy==1.23.5 typing-extensions filelock sympy networkx jinja2 ninja

## ⬇️ Clone PyTorch with Submodules

```bash
git clone --recursive --branch v2.0.1 https://github.com/pytorch/pytorch.git
cd pytorch

## ⚙️ Modify CUDA Architectures (Add 8.7 Support)

Edit the file:

```bash
gedit torch/utils/cpp_extension.py

Locate the supported_arches list and add "8.7":

```bash
supported_arches = [
  '3.5', '3.7', '5.0', '5.2', '5.3',
  '6.0', '6.1', '6.2', '7.0', '7.2',
  '7.5', '8.0', '8.6', '8.7',  # 👈 Add this line
  '8.9', '9.0'
]

## 🔧 Fix CMake Compatibility in Submodules

Run this script in the pytorch directory to patch CMake versions:

```bash
cat << 'EOF' > fix_cmake_min_versions.sh
#!/bin/bash
find . -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \) \
  -exec sed -i -E 's/^[[:space:]]*(cmake_minimum_required\(VERSION )[0-9.]+/\13.25/' {} +
EOF

```bash
chmod +x fix_cmake_min_versions.sh
./fix_cmake_min_versions.sh

## 🧹 Clean Previous Builds

```bash
rm -rf build/ dist/ CMakeCache.txt CMakeFiles/

## 🛠️ Configure Build with CMake + Ninja

```bash
mkdir build && cd build

cmake .. \
  -GNinja \
  -DBUILD_PYTHON=True \
  -DBUILD_TEST=True \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=~/pytorch/torch \
  -DCMAKE_PREFIX_PATH="$VIRTUAL_ENV/lib/python3.10/site-packages" \
  -DNUMPY_INCLUDE_DIR="$VIRTUAL_ENV/lib/python3.10/site-packages/numpy/_core/include" \
  -DPYTHON_EXECUTABLE="$VIRTUAL_ENV/bin/python3" \
  -DPYTHON_INCLUDE_DIR=/usr/include/python3.10 \
  -DPYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.10.so.1.0 \
  -DTORCH_BUILD_VERSION=2.0.1 \
  -DUSE_CUDA=1 \
  -DUSE_DISTRIBUTED=1 \
  -DUSE_NCCL=0 \
  -DUSE_NUMPY=True \
  -DUSE_PYTORCH_QNNPACK=0 \
  -DUSE_QNNPACK=0

## ⚙️ Build PyTorch

```bash
ninja
ninja install

## 📦 Build Wheel

```bash
cd ~/pytorch
python setup.py bdist_wheel

## 🚀 Install the Wheel

```bash
pip install dist/torch-2.0.0a0+gite9ebda2-cp310-cp310-linux_aarch64.whl

    ✅ Replace with the actual wheel file name in your dist/ directory if it’s different.

## ✅ Verify Installation

```bash
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_device_name(0))"

Expected output:

```bash
2.0.0a0+gite9ebda2
True
Orin
