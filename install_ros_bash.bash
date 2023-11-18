#!/bin/bash
user_bash_rc="/home/$USER/.bashrc"
ros_config_dir=$(pwd)
echo '#ros
ros1_distro="noetic"
ros2_distro="foxy"' >> $user_bash_rc
echo "source $ros_config_dir/ros.bash" >> $user_bash_rc
echo '#ros1
ros1_local=""
#ros2
ros2_local=""' >> $user_bash_rc
