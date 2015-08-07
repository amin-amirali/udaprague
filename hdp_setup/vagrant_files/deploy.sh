#!/bin/sh

echo -e "destroying disks \n"
cd ~/projects/udaprague/hdp_setup/vagrant_files/
vagrant destroy -f

echo -e "creating new images from home folder\n"
vagrant up master
vagrant up data1 &
vagrant up data2 &
vagrant up secondary &
wait

vagrant halt

cd ~/VirtualBox\ VMs/
echo -e "removing old folders from each disk\n"
rm -rf /mnt/data1/vm_files/* &
rm -rf /mnt/data2/vm_files/* &
rm -rf /mnt/data3/vm_files/* &
rm -rf /mnt/data4/vm_files/* &
wait

echo -e "make directories just in case they dont exist\n"
mdkir -p /mnt/data1/vm_files &
mdkir -p /mnt/data2/vm_files &
mdkir -p /mnt/data3/vm_files &
mdkir -p /mnt/data4/vm_files &
wait



echo -e "unregistering new VMs from Virtual Box\n"
VBoxManage unregistervm `VBoxManage list vms | grep vagrant_files_data1 | awk '{ print $1 }' | tr -d '"'` &
VBoxManage unregistervm `VBoxManage list vms | grep vagrant_files_data2 | awk '{ print $1 }' | tr -d '"'` &
VBoxManage unregistervm `VBoxManage list vms | grep vagrant_files_secondary | awk '{ print $1 }' | tr -d '"'` &
VBoxManage unregistervm `VBoxManage list vms | grep vagrant_files_master | awk '{ print $1 }' | tr -d '"'` &
wait

cd ~/VirtualBox\ VMs/
echo -e "copying virtual disk data1\n"
cp -R `ls | grep data1`/ /mnt/data2/vm_files
echo -e "copying virtual disk data2\n"
cp -R `ls | grep data2`/ /mnt/data3/vm_files
echo -e "copying virtual disk secondary\n"
cp -R `ls | grep secondary`/ /mnt/data4/vm_files
echo -e "copying virtual disk master\n"
cp -R `ls | grep master`/ /mnt/data1/vm_files
echo -e "removing folders of new disks from home folder\n"
rm -rf `ls | grep data1` &
rm -rf `ls | grep data2` &
rm -rf `ls | grep secondary` &
rm -rf `ls | grep master` &
wait

echo -e "registering new virtual images\n"
VBoxManage registervm /mnt/data1/vm_files/`ls /mnt/data1/vm_files/ | grep master`/*.vbox &
VBoxManage registervm /mnt/data2/vm_files/`ls /mnt/data2/vm_files/ | grep data1`/*.vbox &
VBoxManage registervm /mnt/data3/vm_files/`ls /mnt/data3/vm_files/ | grep data2`/*.vbox &
VBoxManage registervm /mnt/data4/vm_files/`ls /mnt/data4/vm_files/ | grep secondary`/*.vbox &
wait

echo -e "creating clone of disk file and increasing size limit to 930 GB\n"

echo -e "... for master...resize to 200GB\n"
cd /mnt/data1/vm_files/`ls /mnt/data1/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 204800
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "... for data1...\n"
cd /mnt/data2/vm_files/`ls /mnt/data2/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 953344
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "... for data2...\n"
cd /mnt/data3/vm_files/`ls /mnt/data3/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 953344
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "... for secondary...\n"
cd /mnt/data4/vm_files/`ls /mnt/data4/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 953344
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "adding a dvd storage unit and loading it with the previously downloaded gparted live iso\n"
vboxmanage storageattach `ls /mnt/data1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium $HOME"/Downloads/gparted-live-0.22.0-2-i586.iso" &
vboxmanage storageattach `ls /mnt/data2/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium $HOME"/Downloads/gparted-live-0.22.0-2-i586.iso" &
vboxmanage storageattach `ls /mnt/data3/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium $HOME"/Downloads/gparted-live-0.22.0-2-i586.iso" &
vboxmanage storageattach `ls /mnt/data4/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium $HOME"/Downloads/gparted-live-0.22.0-2-i586.iso" &
wait

echo -e "changing boot order -- dvd first, hard disk second\n"
vboxmanage modifyvm `ls /mnt/data1/vm_files` --boot1 dvd --boot2 disk &
vboxmanage modifyvm `ls /mnt/data2/vm_files` --boot1 dvd --boot2 disk &
vboxmanage modifyvm `ls /mnt/data3/vm_files` --boot1 dvd --boot2 disk &
vboxmanage modifyvm `ls /mnt/data4/vm_files` --boot1 dvd --boot2 disk &
wait

echo -e "----------------------------------------------------------\n"
echo -e "\nincrease partition size /dev/sd2 to as much as possible\n"
echo -e "save and reboot"
echo -e "do the same for all images\n"
echo -e "(hit enter when done)\n"
echo -e "----------------------------------------------------------\n"
read _var


echo -e "removing dvd storage unit and restoring boot order\n"
vboxmanage storageattach `ls /mnt/data1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none &
vboxmanage storageattach `ls /mnt/data2/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none &
vboxmanage storageattach `ls /mnt/data3/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none &
vboxmanage storageattach `ls /mnt/data4/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none &
wait

vboxmanage modifyvm `ls /mnt/data1/vm_files` --boot1 disk --boot2 dvd &
vboxmanage modifyvm `ls /mnt/data2/vm_files` --boot1 disk --boot2 dvd &
vboxmanage modifyvm `ls /mnt/data3/vm_files` --boot1 disk --boot2 dvd &
vboxmanage modifyvm `ls /mnt/data4/vm_files` --boot1 disk --boot2 dvd &
wait

echo -e "bringing new virtual images up with vagrant\n"
cd ~/projects/udaprague/hdp_setup/vagrant_files/
vagrant up master &
vagrant up data1 &
vagrant up data2 &
vagrant up secondary &
wait

echo -e "resizing logical unit disk space to occupy all available space. This might take some minutes.\n"
ssh root@master 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
ssh root@data1 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
ssh root@data2 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
ssh root@secondary 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
wait
echo -e "done!\n"

echo -e "access http://master:8080 and configure the hadoop cluster.\n\n\n"

