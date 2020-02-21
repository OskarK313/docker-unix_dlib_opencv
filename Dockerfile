# Python lite
FROM ubuntu:18.04
MAINTAINER Oskar @ Cammy

# Prevent unnecessary internal buffering
ENV PYTHONUNBUFFERED 1

# Add cmake to image - required to install openCV and dlib
RUN apt-get update && \
    apt-get install -y  \
    build-essential \
    nasm \
    cmake \
    gfortran \
    git \
    wget \
    curl \
    graphicsmagick \
    libgraphicsmagick1-dev \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    pkg-config \
    python3-dev \
    python3-numpy \
    python-pip\
    software-properties-common \
    unzip \
    qt5-default \
    && apt-get clean && rm -rf /tmp/* /var/tmp/*

RUN wget https://cmake.org/files/v3.8/cmake-3.8.1.tar.gz && \
    tar xf cmake-3.8.1.tar.gz && \
    cd cmake-3.8.1 && \
    apt-get install  -y openssl libssl-dev checkinstall && \
    ./configure && \
    make && \
    checkinstall && \
    make install


RUN cd ~ && \
    mkdir -p dlib && \
    wget http://dlib.net/files/dlib-19.6.tar.bz2 && \
    tar xvf dlib-19.6.tar.bz2 && \
    cd dlib-19.6/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build . --config Release && \
    make install && \
    ldconfig && \
    cd ..

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


# Clean image
RUN cd  .. && \
    rm -rf \
    OpenCV \
    libjpeg-turbo-1.5.1 \
    cmake-3.8.1.tar.gz \
    libjpeg-turbo_1.5.1.orig.tar.gz \
    cmake-3.8.1 \
    libjpeg-turbo-1.5.1 && \
    apt-get --purge remove -y \
    cmake \
    libgraphicsmagick1-dev \
    libatlas-base-dev \
    libavcodec-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjpeg-dev \
    liblapack-dev \
    libswscale-dev \
    software-properties-common \
    build-essential && \
    apt autoremove -y
