#!/bin/bash
Gooo(){
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
Gooo