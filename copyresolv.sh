#!/bin/sh

addSearchPath="example.com"

kubeletString="/etc/kubernetes/resolv.conf"

function fixresolvconf {
echo "$(date) checking resolv.conf to see if the search string has already been appended"
if grep ^$addSearchPath /etc/kubernetes/resolv.conf
then
	echo "$(date) resolv.conf has already been updated"
else
	sed /search/s/$/\ jnj.com/ /etc/resolv.conf > /mnt/etc/kubernetes/resolv.conf
	echo "$(date) resolv.conf was updated with example.com"
fi
}

function fixkubelet {
echo "checking kubelet service config to see if the new resolv.conf file is being used"

if grep $kubeletString /mnt/etc/systemd/system/kubelet.service
then
	echo "$(date) kubelet.service has already been updated"
else
	sed -i -e '1,/\/etc\/resolv/s/\/etc\/resolv/\/etc\/kubernetes\/resolv/' /mnt/etc/systemd/system/kubelet.service
	echo "$(date) kubelet.service has been updated with new path to resolv.conf"
	kubectl annotate node $MY_NODE_NAME container-linux-update.v1.coreos.com/reboot-needed=true --overwrite
fi
}

while true
	do
		fixresolvconf
		fixkubelet
		sleep 3600
	done


