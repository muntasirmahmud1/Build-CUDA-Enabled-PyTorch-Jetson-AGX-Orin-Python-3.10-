# 🔥 CUDA-Enabled PyTorch Build on Jetson AGX Orin (Python 3.10)

This guide documents how to build and install PyTorch **from source** with **CUDA acceleration** on **NVIDIA Jetson AGX Orin**, targeting Python 3.10. This setup includes CUDA 11.4 support and was tested in a clean environment.

> **Note**: Using a **Python virtual environment is optional**, but recommended to isolate dependencies.

---

## 🧪 System Info

- Device: Jetson AGX Orin
- OS: Ubuntu 20.04
- Python: 3.10.16 (venv)
- CUDA: 11.4
- CMake: ≥3.25 required

---

## 🌀 Optional: Create a Virtual Environment

```bash
python3.10 -m venv ~/venvs/RAG_3_10
source ~/venvs/RAG_3_10/bin/activate
