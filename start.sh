#!/bin/bash
# 配置环境
Packages(){
WhichSys=`uname -o`
Linux="GNU/Linux"
if [[ "$WhichSys" != "$Linux" ]] ; then
echo -e "\n\n\n\n\n\n\n\t\t您需要一个Linux系统\n\n\n\n\n\n\n\n\n"
exit
fi
if grep -Eqii "Arch Linux" /etc/issue || grep -Eq "Arch Linux" /etc/*-release; then
sudo pacman -S axel python python-protobuf android-tools
else
echo -e "\n\n\n\n\n\n\n\t\t您还需要一个ArchLinux\n\n\n\n\n\n\n\n\n"
exit
fi
}
# 检查设备
CheckDevice(){
fastboot $* getvar product 2>&1 | grep "^product: *M2181"
if [ $? -ne 0  ] ; then echo -e "\n\n\n\n\n\n\n\n\t\t请插入正确的设备\n\n\n\n\n\n\n\n"; exit 1; fi
}
# 准备刷机包
PrePare(){
MD5="c507c3f9d5da272611d11f486c4a4c4c"
git clone https://gitee.com/baizhi958216/lineage-os_scripts.git --depth=1
if [ ! -d "lineage-os_scripts" ];then
echo -e "\n\n\n\n\n\n\n\t\t解压脚本不存在，请重新下载\n\n\n\n\n\n\n\n\n"
exit
else
axel -n `nproc` https://firmware.meizu.com/Firmware/Flyme/meizu18/9.2.5.2/cn/20211215152209/6c4a4c4c/update.zip
if [[ `md5sum update.zip|cut -d" " -f1` == $MD5 ]] ; then
unzip update.zip payload.bin
python lineage-os_scripts/update-payload-extractor/extract.py payload.bin --output_dir ./out_m2181
else
echo -e "\n\n\n\n\n\n\n\t\t刷机包完整性检验失败，请重新下载\n\n\n\n\n\n\n\n\n"
exit
fi
fi
}
# 刷入
Gooo(){
cd ./out_m2181
FastbootFiles=(abl boot dsp hyp modem tz vbmeta_system xbl aop cpucp dtbo keymaster qupfw uefisecapp vendor_boot bluetooth devcfg featenabler logo shrm vbmeta xbl_config)
FastbootdFiles=(odm product system_ext system vendor)
echo -e "\n\n\n\n\n\n\n\n\t\t5秒后开始刷入，请勿挪动数据线或设备\n\n\n\n\n\n\n\n"
sleep 5
for i in ${FastbootFiles[*]}
do
fastboot flash $i $i.img
done
fastboot reboot fastboot
for i in ${FastbootdFiles[*]}
do
fastboot flash $i $i.img
done
fastboot reboot
}
Packages
CheckDevice
PrePare
Gooo
