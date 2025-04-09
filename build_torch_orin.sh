#!/bin/bash

export USE_NCCL=0
export USE_DISTRIBUTED=1
export USE_QNNPACK=0
export USE_PYTORCH_QNNPACK=0
export TORCH_CUDA_ARCH_LIST="8.7"
export PYTORCH_BUILD_VERSION=2.0.1
export PYTORCH_BUILD_NUMBER=1
export CMAKE_POLICY_VERSION=3.25

python3 setup.py clean
rm -rf build
cmake -DCMAKE_POLICY_VERSION=3.25 .
python3 setup.py bdist_wheel
