#!/bin/sh

echo -e "destroying disks \n"
cd /home/amin/Documents/projects/vagrant-hdp-ambari/
vagrant destroy -f

echo -e "creating new images from home folder\n"
cd /home/amin/Documents/projects/vagrant-hdp-ambari/
vagrant up
vagrant halt

cd /home/amin/VirtualBox\ VMs/
echo -e "removing old folders from each disk\n"
rm -rf /mnt/localDisk/vm_files/*
rm -rf /mnt/sdb1/vm_files/*
rm -rf /mnt/sdc1/vm_files/*
rm -rf /mnt/sdd1/vm_files/*

echo -e "unregistering new VMs from Virtual Box\n"
VBoxManage unregistervm `VBoxManage list vms | grep vagrant-hdp-ambari_data1 | awk '{ print $1 }' | tr -d '"'`
VBoxManage unregistervm `VBoxManage list vms | grep vagrant-hdp-ambari_data2 | awk '{ print $1 }' | tr -d '"'`
VBoxManage unregistervm `VBoxManage list vms | grep vagrant-hdp-ambari_data3 | awk '{ print $1 }' | tr -d '"'`
VBoxManage unregistervm `VBoxManage list vms | grep vagrant-hdp-ambari_master | awk '{ print $1 }' | tr -d '"'`

cd /home/amin/VirtualBox\ VMs/
echo -e "copying virtual disk data1\n"
cp -R `ls | grep data1`/ /mnt/sdb1/vm_files
echo -e "copying virtual disk data2\n"
cp -R `ls | grep data2`/ /mnt/sdc1/vm_files
echo -e "copying virtual disk data3\n"
cp -R `ls | grep data3`/ /mnt/sdd1/vm_files
echo -e "copying virtual disk master\n"
cp -R `ls | grep master`/ /mnt/localDisk/vm_files
echo -e "removing folders of new disks from home folder\n"
rm -rf `ls | grep data1`
rm -rf `ls | grep data2`
rm -rf `ls | grep data3`
rm -rf `ls | grep master`

echo -e "registering new virtual images\n"
VBoxManage registervm /mnt/localDisk/vm_files/`ls /mnt/localDisk/vm_files/ | grep master`/*.vbox
VBoxManage registervm /mnt/sdb1/vm_files/`ls /mnt/sdb1/vm_files/ | grep data1`/*.vbox
VBoxManage registervm /mnt/sdc1/vm_files/`ls /mnt/sdc1/vm_files/ | grep data2`/*.vbox
VBoxManage registervm /mnt/sdd1/vm_files/`ls /mnt/sdd1/vm_files/ | grep data3`/*.vbox

echo -e "creating clone of disk file and increasing size limit to 930 GB\n"

echo -e "... for master...resize to 200GB\n"
cd /mnt/localDisk/vm_files/`ls /mnt/localDisk/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 204800
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "... for data1...\n"
cd /mnt/sdb1/vm_files/`ls /mnt/sdb1/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 953344
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "... for data2...\n"
cd /mnt/sdc1/vm_files/`ls /mnt/sdc1/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 953344
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "... for data3...\n"
cd /mnt/sdd1/vm_files/`ls /mnt/sdd1/vm_files`
VBoxManage clonehd `ls | grep .vmdk` `ls | grep .vmdk | sed -e 's/.vmdk//'`.vdi --format vdi 
VBoxManage modifyhd `ls | grep .vdi` --resize 953344
VBoxManage modifyvm `ls ..` --hda none
VBoxManage modifyvm `ls ..` --hda `ls | grep .vdi`
rm -f `ls | grep .vmdk`

echo -e "adding a dvd storage unit and loadint it with the previously downloaded gparted live iso\n"
vboxmanage storageattach `ls /mnt/localDisk/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium "/home/amin/Downloads/gparted-live-0.22.0-2-i586.iso"
vboxmanage storageattach `ls /mnt/sdb1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium "/home/amin/Downloads/gparted-live-0.22.0-2-i586.iso"
vboxmanage storageattach `ls /mnt/sdc1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium "/home/amin/Downloads/gparted-live-0.22.0-2-i586.iso"
vboxmanage storageattach `ls /mnt/sdd1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium "/home/amin/Downloads/gparted-live-0.22.0-2-i586.iso"
echo -e "changing boot order -- dvd first, hard disk second\n"
vboxmanage modifyvm `ls /mnt/localDisk/vm_files` --boot1 dvd --boot2 disk
vboxmanage modifyvm `ls /mnt/sdb1/vm_files` --boot1 dvd --boot2 disk
vboxmanage modifyvm `ls /mnt/sdc1/vm_files` --boot1 dvd --boot2 disk
vboxmanage modifyvm `ls /mnt/sdd1/vm_files` --boot1 dvd --boot2 disk

echo -e "----------------------------------------------------------\n"
echo -e "\nincrease partition size /dev/sd2 to as much as possible\n"
echo -e "save and reboot"
echo -e "do the same for all images that represent data nodes\n"
echo -e "(hit enter when done)\n"
echo -e "----------------------------------------------------------\n"
read _var


echo -e "removing dvd storage unit and restoring boot order\n"
vboxmanage storageattach `ls /mnt/localDisk/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none
vboxmanage storageattach `ls /mnt/sdb1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none
vboxmanage storageattach `ls /mnt/sdc1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none
vboxmanage storageattach `ls /mnt/sdd1/vm_files` --storagectl "IDE Controller" --port 0 --device 1 --type dvddrive --medium none
vboxmanage modifyvm `ls /mnt/localDisk/vm_files` --boot1 disk --boot2 dvd
vboxmanage modifyvm `ls /mnt/sdb1/vm_files` --boot1 disk --boot2 dvd
vboxmanage modifyvm `ls /mnt/sdc1/vm_files` --boot1 disk --boot2 dvd
vboxmanage modifyvm `ls /mnt/sdd1/vm_files` --boot1 disk --boot2 dvd

echo -e "bringing new virtual images up with vagrant\n"
cd /home/amin/Documents/projects/vagrant-hdp-ambari/
vagrant up

echo -e "resizing logical unit disk space to occupy all available space. This might take some minutes.\n"
ssh root@master 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
ssh root@data1 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
ssh root@data2 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
ssh root@data3 'lvextend -l +100%FREE /dev/mapper/VolGroup-lv_root; resize2fs /dev/mapper/VolGroup-lv_root' &
wait
echo -e "done!\n"

echo -e "access http://master:8080 and configure the hadoop cluster.\n\n\n"

