#!/bin/bash

# This script will install pytorch, torchvision, torchtext and spacy on nano. 
# If you have any of these installed already on your machine, you can skip those.

sudo apt-get -y update
sudo apt-get -y upgrade
#Dependencies
sudo apt-get install python3-setuptools

#Installing PyTorch
#For latest PyTorch refer original Nvidia Jetson Nano thread - https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano/.
#一般需要翻墙下载，可以提前下载好，放到同目录下，注释这行代码
# wget https://nvidia.box.com/shared/static/ncgzus5o23uck9i5oth2n8n06k340l6k.whl -O torch-1.4.0-cp36-cp36m-linux_aarch64.whl
sudo apt-get install python3-pip libopenblas-base
sudo pip3 install Cython
sudo pip3 install numpy torch-1.4.0-cp36-cp36m-linux_aarch64.whl

#Installing torchvision
#For latest torchvision refer original Nvidia Jetson Nano thread - https://devtalk.nvidia.com/default/topic/1049071/jetson-nano/pytorch-for-jetson-nano/.
sudo apt-get install libjpeg-dev zlib1g-dev
git clone --branch v0.5.0 https://github.com/pytorch/vision torchvision   # see below for version of torchvision to download
cd torchvision
sudo python setup.py install
cd ../  # attempting to load torchvision from build dir will result in import error

#Installing spaCy
#Installing dependency sentencepiece
sudo apt-get install cmake build-essential pkg-config libgoogle-perftools-dev
git clone https://github.com/google/sentencepiece.git
cd sentencepiece
mkdir build
cd build
cmake ..
make -j $(nproc)
sudo make install
sudo ldconfig -v
cd python
python3 setup.py build
sudo python3 setup.py install
cd ../../

git clone https://github.com/explosion/spaCy
cd spaCy/
export PYTHONPATH=`pwd`
export BLIS_ARCH=generic
sudo pip3 install -r requirements.txt
sudo python3 setup.py build_ext --inplace
sudo python3 setup.py install
python3 -m spacy download en_core_web_sm
cd ../

#Installing torchtext
git clone https://github.com/pytorch/text.git
cd text
sudo pip3 install -r requirements.txt
sudo python3 setup.py install
cd ../

echo "done installing PyTorch, torchvision, spaCy, torchtext"
