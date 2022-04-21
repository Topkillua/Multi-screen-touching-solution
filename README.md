# Multi-screen-touching-solution
Current Version：touchmap_2.0.3kord_arm64.deb

# Description
This deb package is used to slove the multiscreen touching problem.  
 -support the hot-plugging action  
 -support the touch pen device mapping  
 -support Hanvon Tablet

# 安装步骤
1, 该包在安装时需要先卸载低版本的包，执行“sudo dpkg -P touchmap”即可。该包有两个
依赖包：python3-pyudev_0.22.0-1kord-4_all.deb，xinput_1.6.2-1kord_arm64.deb，在>安装touchmap包之前如未安装，“sudo dpkg -i python3-pyudev_0.22.0-1kord-4_all.deb xinput_1.6.2-1kord_arm64.deb”安装即可，如已安装请忽略此步骤。查看方法“dpkg -l | grep xinput” “dpkg -l | grep python3-pyudev”

2, 安装touchmap_2.0.1kord_arm64.deb
sudo dpkg -i touchmap_2.0.1kord_arm64.deb

3,安装包成功之后，点击开始菜单->所有程序->屏幕触摸设置,进入初始化设置界面，此操>作在安装之后进行一次即可，点击相应屏幕与触摸设备，设置映射关系

4,当确认屏幕的触摸都正确后，重启（部分功能重启生效）。

