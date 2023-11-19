#!/usr/bin/env bash 

if test -n "$ZSH_VERSION"; then
	ros_config_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
elif test -n "$BASH_VERSION"; then
	ros_config_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
else
	ros_config_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
fi

remove_paths () 
{ 
	if test -n "$ZSH_VERSION"; then
		IFS=":" read -rA PATHES <<< "$1";
	elif test -n "$BASH_VERSION"; then
		IFS=':' read -ra PATHES <<< "$1";
	fi
    local THISPATH="";
    local path;
    for path in "${PATHES[@]}";
    do
        local to_remove=0;
        local i;
        for ((i=2; i <="$#"; i++ ))
        do
            if [[ $path = *"${!i}"* ]]; then
                to_remove=1;
                break;
            fi;
        done;
        if [ $to_remove -eq 0 ]; then
            THISPATH="$THISPATH:$path";
        fi;
    done;
    echo $THISPATH | cut -c2-
}

remove_all_paths () 
{ 
    export AMENT_PREFIX_PATH=$(remove_paths "$AMENT_PREFIX_PATH" $@);
    export AMENT_CURRENT_PREFIX=$(remove_paths "$AMENT_CURRENT_PREFIX" $@);
    export PYTHONPATH=$(remove_paths "$PYTHONPATH" $@);
    export CMAKE_PREFIX_PATH=$(remove_paths "$CMAKE_PREFIX_PATH" $@);
    export PATH=$(remove_paths "$PATH" $@);
    export LD_LIBRARY_PATH=$(remove_paths "$LD_LIBRARY_PATH" $@)
}

register_ros_workspace () 
{ 
    local subs="/ /install/ /devel/";
    local sub;
    # echo "0) $1";
    for sub in $subs;
    do
        #echo "1) $1${sub}$2setup.bash";
        if [ -f "$1${sub}$2setup.bash" ]; then
            # echo "2) $ROS_DISTRO";
            # echo "3) source $1${sub}$2setup.bash";
            source "$1${sub}$2setup.bash";
            # echo "4) $ROS_DISTRO";
            return;
        fi;
    done
}

ros1ws () 
{ 
    remove_all_paths $ros2_workspaces;
    unset ROS_DISTRO;
    register_ros_workspace $ros1_base "";
    local ws;
    for ws in $ros1_local;
    do
        register_ros_workspace $ws $ros_local_prefix;
    done;
    local ROS1_COLOR="\[\033[35m\]"; #magenta
    local ROSVNAME="ROS-";
    export PS1="$ROS1_COLOR[$ROSVNAME$ROS_DISTRO]$PS1D";
    . /usr/share/gazebo/setup.sh
}

ros2ws () 
{ 
    remove_all_paths $ros1_workspaces;
    unset ROS_DISTRO;
    register_ros_workspace $ros2_base "";
    local ws;
    for ws in $ros2_local;
    do
        register_ros_workspace $ws $ros_local_prefix;
    done;
    local ROS2_COLOR="\[\033[31m\]"; #red
    local ROSVNAME="ROS2-";
    export PS1="$ROS2_COLOR[$ROSVNAME$ROS_DISTRO]$PS1D";
    . /usr/share/gazebo/setup.sh
}

ros_exit()
{
    remove_all_paths $ros1_workspaces;
    remove_all_paths $ros2_workspaces;
    unset ROS_DISTRO;
    export PS1="$PS1D";
}

PS1D=$PS1

#ros
ros1_distro_names="box c diamondback electric fuerte groovy hydro indigo jade kinetic lunar melodic noetic"
ros2_distro_names="ardent bouncy cystal dashing eloquent foxy humble iron"

rdcp_file=$ros_config_dir/.ros_distro_config_profile
if [[ -f "${rdcp_file}" ]]; then
	. $rdcp_file
fi

ros_local_prefix="local_"
#ros1
ros1_base="/opt/ros/$ros1_distro"
#ros2
ros2_base="/opt/ros/$ros2_distro"

rcp_file=$ros_config_dir/.ros_config_profile
if [[ -f "${rcp_file}" ]]; then
	. $rcp_file
fi
