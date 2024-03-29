#!/bin/bash
set -e

#overlay the ROS environemnt
source "/opt/ros/$ROS_DISTRO/setup.bash"
exec "$@"