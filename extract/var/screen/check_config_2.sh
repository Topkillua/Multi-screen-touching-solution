#!/bin/bash
usr_config_path="/home/$USER/.config/touchcfg.ini"

change_num=0
lineCount=0
touch_id_change_list=()
touch_node_change_list=()
while read LINE1
do
	let lineCount+=1
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
		touch_id_info=$(xinput | grep $configId | grep "$configName")
		configName_b=${configName//" "/"_"}
		touch_name=$(udevadm info $configNode | grep "$configName_b" )
        	if [ "$touch_screen" == "" ]||[ "$touch_id_info" == "" ]||[ "$touch_name" == "" ];then
                	echo "bad solution for this screen, automatication comparasion tried"
                	for touch_id in $(xinput | grep -i -E "$configName" | cut -d '=' -f 2 | cut -f 1)
                	do
                        	input_dev=$(xinput list-props $touch_id | grep "Device Node" | awk -F : '{print $2}' | awk -F \" '{print $2}' | awk '{print $1}')
				echo $input_dev
                        	touch_screen=$(udevadm info $input_dev | grep "ID_INPUT_TOUCHSCREEN\|ID_INPUT_TABLET")
				echo $touch_screen
                        	if [ "$touch_screen" == "" ];then
                                	continue
                        	fi
                        echo "Need to update config"
			echo "Node change: ($configNode) --- ($input_dev)"
			touch_node_change_list[change_num]=$lineCount
                        touch_node_change_list[change_num+1]=$configNode
                        touch_node_change_list[change_num+2]=$input_dev
			echo "Id change: ($configId) --- ($touch_id)"
			touch_id_change_list[change_num]=$lineCount
			touch_id_change_list[change_num]=$configId
			touch_id_change_list[change_num+1]=$touch_id		
			let change_num+=3
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
	tmp="line="${touch_id_change_list[count]}
	tmp1="id="${touch_id_change_list[count+1]}
	tmp2="id="${touch_id_change_list[count+2]}
	echo $tmp
	echo $tmp1
        echo $tmp2
	sed -i "${tmp-1}s/$tmp1/$tmp2" $usr_config_path
	tmp="line="${touch_node_change_list[count]}
	tmp1="devnode="${touch_node_change_list[count+1]}
	tmp2="devnode="${touch_node_change_list[count+2]}
	tmp1=${tmp1//\//\\/}
        tmp2=${tmp2//\//\\/}
	echo $tmp
	echo $tmp1
	echo $tmp2
	sed -i "${tmp-2}s/$tmp1/$tmp2" $usr_config_path
	let count+=3
done
unset touch_node_change_list touch_id_change_list change_num count
