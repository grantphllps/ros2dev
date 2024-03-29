FROM ubuntu:22.04

# Setup timezone
RUN echo 'Etc/UTC' > /etc/timezone \
    && ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && apt-get update \
    && apt-get install -q -y --no-install-recommends tzdata \
    && rm -rf /var/lib/apt/lists/*

# Setup the environments
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV ROS_DISTRO=iron
ENV HOME=/home/

# Install some helpful utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
        iputils-ping \
        net-tools \
        python3 \
        python3-pip \
        nano \
        git \
        clang \
        g++ \
        rsync \
        zip \
        make \
        cmake \
        curl \
        wget \
        build-essential \
        lsb-release \
        ca-certificates \
        dirmngr \
        gnupg2 \
        netbase \
        htop \
        nmap \
    && rm -rf /var/lib/apt/lists/*

    RUN pip3 install \
    numpy \
    pandas \
    matplotlib \
    pyserial \
    pymavlink

RUN apt update && apt install -y software-properties-common
RUN add-apt-repository universe

RUN apt update && apt install curl -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update && apt install ros-dev-tools -y

RUN apt update && apt upgrade -y
RUN apt install ros-${ROS_DISTRO}-desktop -y

ENV DISPLAY=:0
ENV GAZEBO_MODEL_PATH=/home/ardupilot_gazebo/models

WORKDIR ${HOME}
COPY ros_entrypoint.sh /
RUN ["chmod", "+x", "/ros_entrypoint.sh"]
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]