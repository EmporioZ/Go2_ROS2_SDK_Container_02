# choose version of ubuntu
FROM ubuntu:22.04

# set work 
WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei
RUN echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Asia select Taipei' | debconf-set-selections


RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    clang \
    portaudio19-dev \
    lsb-release \
    gnupg \
    software-properties-common \
    tzdata

# add ROS2 source
RUN mkdir -p /etc/apt/keyrings
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O /etc/apt/keyrings/ros.key
RUN chmod +r /etc/apt/keyrings/ros.key
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/ros.key] http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros2.list

# apt we can choose ros base/desktop
RUN apt-get update && apt-get install -y \
    #ros-humble-ros-base \
    ros-humble-desktop \
    ros-humble-image-tools \
    ros-humble-vision-msgs \
    python3-colcon-common-extensions \
    python3-rosdep \
    ros-humble-ament-cmake  

# set CMAKE_PREFIX_PATH
ENV CMAKE_PREFIX_PATH /opt/ros/humble/share/ament_cmake:$CMAKE_PREFIX_PATH

# init rosdep
RUN rosdep init
RUN rosdep update

# git clone go2_ros2_sdk
RUN git clone --recurse-submodules https://github.com/abizovnuralem/go2_ros2_sdk.git src

# install Python
WORKDIR /app/src
RUN pip3 install -r requirements.txt

# colcon go2_ros2_sdk
WORKDIR /app
RUN /bin/bash -c 'source /opt/ros/humble/setup.bash && \
    rosdep install --from-paths src --ignore-src -r -y && \
    colcon build --packages-up-to unitree_go'

# set PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV ROS_DISTRO=humble
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

# final
#RUN apt-get clean && rm -rf /var/lib/apt/lists/*  


