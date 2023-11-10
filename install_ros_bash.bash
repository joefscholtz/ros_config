user_bash_rc="/home/$USER/.bashrc"
ros_config_dir=$(pwd)
echo '#ros
ros1_distro="noetic"
ros2_distro="foxy"' >> $user_bash_rc
echo "source $ros_config_dir/ros.bash" >> $user_bash_rc
echo '#ros1
ros1_local="/home/joe/catkin_ws /home/joe/ecn_catkin /home/joe/integ_catkin"
#ros2
ros2_local="/opt/ros/foxy /home/joe/ros2_ws"' >> $user_bash_rc