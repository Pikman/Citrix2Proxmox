VMNAME=Vietnam_Data #тут имя машины в ситрихе
PXID=682 #а тут ид для новой машины в проксмохе

PXNAME=$(echo $VMNAME | tr _' ' -)
VMUUID=$(xe vm-list | grep "$VMNAME" -C 1 | head -1 | cut -d : -f 2 | cut -c2-)
sRAM=$(xe vm-param-get uuid=$VMUUID param-name=memory-static-max)
RAM=$((sRAM/1024/1024))
VCPU=$(xe vm-param-get uuid=$VMUUID param-name=VCPUs-max)
echo name: $VMNAME, PVE-name: $PXNAME, ID: $PXID
echo ram: $RAM, cpu: $VCPU

ssh 172.16.11.203 "qm create $PXID --name $PXNAME --memory $RAM --cores $VCPU --net0 virtio,bridge=vmbr0 --virtio0 "HDD:$PXID/$PXNAME".qcow2"
ssh 172.16.11.203 "mkdir /mnt/hdd14/images/$PXID/ && \
qemu-img convert -f vpc -O qcow2 /mnt/ssd1/smb/$VMNAME/*.vhd /mnt/hdd14/images/$PXID/$PXNAME.qcow2"
