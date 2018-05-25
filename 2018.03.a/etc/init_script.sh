#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config 
echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"syslog\",\"awslogs\"] >> /etc/ecs/ecs.config 

if [ -e /dev/xvdb ]; then
	if file -s /dev/xvdb | grep data > /dev/null; then
		echo "Formatting data volume..."
		mkfs -t ext4 /dev/xvdb
	fi

	echo "Mounting data volume..."
	mkdir -p /ecs
	mount /dev/xvdb /ecs
	chown ec2-user:ec2-user -R /ecs
	chmod 777 -R /ecs

	cp /etc/fstab /etc/fstab.orig
	echo "/dev/xvdb   /ecs   ext4    defaults,nofail  0   2" | tee --append /etc/fstab

	reboot
fi
