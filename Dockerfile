# Python lite
FROM ubuntu:20.04
MAINTAINER Oskar @ Cammy

# Prevent unnecessary internal buffering
ENV PYTHONUNBUFFERED 1

# Add cmake to image - required to install openCV and dlib

RUN apt-get update
RUN apt-get install -y --fix-missing \
    build-essential \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    python3-pip\
    software-properties-common \
    zip\
    qt5-default \
    nasm \
    dh-autoreconf \
    openssl \
    checkinstall \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN cd ~ && \
    mkdir -p dlib && \
    pip3 install setuptools && \
    git clone -b 'v19.19' --single-branch https://github.com/davisking/dlib.git dlib/ && \
    cd  dlib/ && \
    python3 setup.py install


RUN wget https://cmake.org/files/v3.8/cmake-3.8.1.tar.gz && \
    tar xf cmake-3.8.1.tar.gz && \
    cd cmake-3.8.1 && \
    apt-get install  && \
    ./configure && \
    make && \
    checkinstall && \
    make install

RUN mkdir -p ~/opencv cd ~/opencv && \
    wget https://github.com/Itseez/opencv/archive/4.1.1.zip && \
    unzip 4.1.1.zip && \
    rm 4.1.1.zip && \
    mv opencv-4.1.1 OpenCV && \
    cd OpenCV && \
    mkdir build && \
    cd build && \
    cmake \
    -DWITH_QT=ON \
    -DWITH_OPENGL=OFF \
    -DFORCE_VTK=ON \
    -DWITH_TBB=ON \
    -DWITH_GDAL=ON \
    -DWITH_XINE=ON \
    -DBUILD_EXAMPLES=OFF .. && \
    make -j4 && \
    make install && \
    ldconfig

RUN wget https://launchpad.net/ubuntu/+archive/primary/+files/libjpeg-turbo_1.5.1.orig.tar.gz && \
    tar xvf libjpeg-turbo_1.5.1.orig.tar.gz && \
    cd libjpeg-turbo-1.5.1/ && \
    autoreconf -fiv && \
    mkdir build  && \
    cd build && \
    sh ../configure --prefix=/usr/libjpeg-turbo --mandir=/usr/share/man --with-jpeg8 --enable-static --docdir=/usr/share/doc/libjpeg-turbo-1.5.1 && \
    make install


RUN apt-get --purge remove -y \
    zip \
    curl \
    wget \
    cmake \
    python3-dev
