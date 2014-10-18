#!/bin/bash
VM=`VBoxManage list vms | grep docker-workshop | tr -d '"' | cut -f 1 -d ' '`
if [[ -z $VM ]]; then
	echo VM not found
	exit 1
fi
VBoxManage export $VM -o snapshot.ovf

ls -al

