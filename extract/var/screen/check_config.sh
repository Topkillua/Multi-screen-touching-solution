#!/bin/bash
usr_config_path="/home/$USER/.config/touchcfg.ini"

change_num=0
touch_id_change_list=()
touch_node_change_list=()
while read LINE1
do
	tmp1=`echo $LINE1 | awk -F "=" '{print $1}'`
	if [ "$tmp1" == "devnode" ];then
		configNode=`echo $LINE1 | awk -F "=" '{print $2}'`
	fi
	if [ "$tmp1" == "id" ];then
                configId=`echo $LINE1 | awk -F "=" '{print $2}'`
        fi
	if [ "$tmp1" == "name" ];then
                configName=`echo $LINE1 | awk -F "=" '{print $2}'`
        fi
	if [ "${configNode}" ]&&[ "${configId}" ]&&[ "${configName}" ];then
		touch_screen=$(udevadm info $configNode | grep "ID_INPUT_TOUCHSCREEN\|ID_INPUT_TABLET")
		echo $touch_screen
		touch_id=$(xinput | grep $configId | grep "$configName")
		echo $touch_id
        	if [ "$touch_screen" == "" ]||[ "$touch_id" == "" ];then
                	echo "bad solution for this screen, automatication comparasion tried"
                	for touch_id in $(xinput | grep -i -E "$configName" | cut -d '=' -f 2 | cut -f 1)
                	do
                        	input_dev=$(xinput list-props $touch_id | grep "Device Node" | awk -F : '{print $2}' | awk -F \" '{print $2}' | awk '{print $1}')
                        	touch_screen=$(udevadm info $input_dev | grep "ID_INPUT_TOUCHSCREEN\|ID_INPUT_TABLET")
                        	if [ "$touch_screen" == "" ];then
                                	continue
                        	fi
                        echo "Need to update config"
			echo "Node change: ($configNode) --- ($input_dev)"
                        touch_node_change_list[change_num]=$configNode
                        touch_node_change_list[change_num+1]=$input_dev
			echo "Id change: ($configId) --- ($touch_id)"
			touch_id_change_list[change_num]=$configId
			touch_id_change_list[change_num+1]=$touch_id		
			let change_num+=2
                	done
        	fi
		echo "Reset Valuables"
		unset configNode configId configName
	fi
done < $usr_config_path

count=0

while [ 1 ]
do
	if [ "$count" == "$change_num" ];then
                echo "Config renewed success"
                break;
        fi
	tmp1="id="${touch_id_change_list[count]}
	tmp2="id="${touch_id_change_list[count+1]}
	echo $tmp1
        echo $tmp2
	sed -i "s/$tmp1/$tmp2/g" $usr_config_path
	tmp1="devnode="${touch_node_change_list[count]}
	tmp2="devnode="${touch_node_change_list[count+1]}
	tmp1=${tmp1//\//\\/}
        tmp2=${tmp2//\//\\/}
	echo $tmp1
	echo $tmp2
	sed -i "s/$tmp1/$tmp2/g" $usr_config_path
	let count+=2
done
unset touch_node_change_list touch_id_change_list change_num count
