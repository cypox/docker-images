# use latest-py3 in case of CPU only
FROM tensorflow/tensorflow:latest-gpu-py3

# install packages
RUN apt update && apt install -q -y \
    build-essential \
    dirmngr \
    gnupg2 \
    lsb-release \
    wget \
    git \
    less \
    python-pip \
    tmux \
    vim \
    && rm -rf /var/lib/apt/lists/*

# setup keysq
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys \
    C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > \
    /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN DEBIAN_FRONTEND="noninteractive" apt update && DEBIAN_FRONTEND="noninteractive" apt -y install -y \
    python-rosdep \
    python-rosinstall \
    python-wstool \
    python-rosinstall-generator \
    python-vcstools \
    python-catkin-tools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO kinetic
RUN apt update && apt install -y \
    ros-melodic-ros-base=1.4.1-0* ros-melodic-cv-bridge \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo

#RUN apt install ros-melodic-cv-bridge

RUN pip3 install --upgrade pip

# Install some python packages for vision_node to work
RUN pip3 install pyyaml rospkg gym opencv-python defusedxml

# Disable certificate check
RUN git config --global http.sslverify false
RUN git clone https://KsjGQ6xVCP5jx5-2GURB@gitlab.ausy.com/ausy/rd/robotic/robin_vision.git

RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc
# tensorflow's default working dir
WORKDIR /root/robin_vision
