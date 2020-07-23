# TX2_jetpack 系统环境配置

一、#/*TX2升级cmake*/
我的应用场景要编译TensorRT进行目标检测，yolo-darknet/tkCUDNN，需要最低cmake版本为3.15,而Jetpack 4.3刷机后自带的为3.12.
使用以下两条命令都是失败的
1   sudo pip3 install cmake==3.13
2   sudo apt-get install python3-cmake
因此，只能从源码安装camke。
1. 删除默认的cmake
sudo apt remove cmake
sudo apt purge --auto-remove cmake

2. 从官网下载所需版本，解压，创建build文件夹
sudo apt-get install build-essential
$ weget https://cmake.org/files/v3.18/cmake-3.18.0.tar.gz
$ tar xf cmake-3.18.30.tar.gz
$ cd cmake-3.18.0
$ ./configure
$ make -j7
$ sudo make install

3. 移动路径
sudo cp ./bin/cmake /usr/bin/

4.验证安装结果
cmake --version
输出：
cmake version 3.13.3
CMake suite maintained and supported by Kitware (kitware.com/cmake).

二、TX2+jetpack4.3源码编译opencv3.4.10+contrib3.4.10
（1）安装依赖环境
sudo apt-get purge libopencv*
sudo apt-get purge python-numpy
sudo apt autoremove
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install --only-upgrade g++-5 cpp-5 gcc-5
sudo apt-get install build-essential make cmake cmake-curses-gui \
                   g++ libavformat-dev libavutil-dev \
                   libswscale-dev libv4l-dev libeigen3-dev \
                   libglew-dev libgtk2.0-dev
sudo apt-get install libdc1394-22-dev libxine2-dev \
                   libgstreamer1.0-dev \
                   libgstreamer-plugins-base1.0-dev
sudo apt-get install libjpeg8-dev libjpeg-turbo8-dev libtiff5-dev \
                   libjasper-dev libpng12-dev libavcodec-dev
sudo apt-get install libxvidcore-dev libx264-dev libgtk-3-dev \
                   libatlas-base-dev gfortran
sudo apt-get install libopenblas-dev liblapack-dev liblapacke-dev
sudo apt-get install qt5-default
（2）绑定Python2-Python3
# Python 2.7
sudo apt-get install -y python-dev  python-numpy  python-py  python-pytest
# Python 3.6
sudo apt-get install -y python3-dev python3-numpy python3-py python3-pytest
# GStreamer support
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 
（3）下载opencv源码
下载opencv，下载地址：https://opencv.org/releases/
点击Sources进行下载自己需要的版本，我下载的是3.4.10，亲测成功，其他版本也可以。
解压opencv到home下，然后将opencv_contrib解压到opencv目录下。
cd 
cd opencv
mkdir build cd build 
新建CmakeList.txt,将下面cmake指令填写进去，
cmake指令
cmake \  
    -DCMAKE_BUILD_TYPE=Release \  
    -DCMAKE_INSTALL_PREFIX=/usr/local \  
    -DBUILD_PNG=OFF \  
    -DBUILD_TIFF=OFF \  
    -DBUILD_TBB=OFF \  
    -DBUILD_JPEG=OFF \  
    -DBUILD_JASPER=OFF \  
    -DBUILD_ZLIB=OFF \  
    -DBUILD_EXAMPLES=OFF \  
    -DBUILD_opencv_java=OFF \  
    -DBUILD_opencv_python2=ON \  
    -DBUILD_opencv_python3=ON \  
    -DENABLE_PRECOMPILED_HEADERS=OFF \  
    -DWITH_OPENCL=OFF \  
    -DWITH_OPENMP=OFF \  
    -DWITH_FFMPEG=ON \  
    -DWITH_GSTREAMER=OFF \  
    -DWITH_GSTREAMER_0_10=OFF \  
    -DWITH_CUDA=ON \  
    -DWITH_GTK=ON \  
    -DWITH_VTK=OFF \  
    -DWITH_TBB=ON \  
    -DWITH_1394=OFF \  
    -DWITH_OPENEXR=OFF \  
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-10.0 \  
    -DCUDA_ARCH_BIN="6.2" \  
    -DOPENCV_EXTRA_MODULES_PATH = /home/nvidia/OpenCV3.4.10/opencv_contrib-3.4.10/modules \
    -DCUDA_ARCH_PTX="" \  
    -DINSTALL_C_EXAMPLES=ON \  
    -DINSTALL_TESTS=OFF \  
    -DOPENCV_TEST_DATA_PATH="" \  
    ../opencv  
然后执行cmake ..
make -j7 ；漫长的等待
sudo make install 
最后配置环境
用gedit打开，sudo gedit /etc/ld.so.conf
在文件中加上一行 include /usr/loacal/lib
其中/user/loacal是opencv安装路径也就是makefile中指定的安装路
运行sudo ldconfig,
修改bash.bashrc文件，sudo gedit /etc/bash.bashrc 
在文件末尾加入：
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH
然后在命令行中输入
source /etc/bash.bashrc
至此，opencv编译完成，按照如上流程一般不会出现问题。
在命令行中输入如下命令：pkg-config opencv --modversion

三、TX2+jetpack4.3源码编译tkDNN