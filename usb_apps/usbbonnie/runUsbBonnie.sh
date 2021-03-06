#!/bin/sh

for DEV in /sys/block/sd*
do
	if readlink $DEV | grep -q usb
	then
		DEV=`basename $DEV`
		VENDOR=`udevadm info -q all --name sda | grep "ID_VENDOR=" | sed 's/E: ID_VENDOR=\(.*\)$/\1/'`
		MODEL=`udevadm info -q all --name sda | grep "ID_MODEL=" | sed 's/E: ID_MODEL=\(.*\)$/\1/'`


		echo "USB device /dev/$DEV is a $VENDOR $MODEL"
		if [ -d /sys/block/${DEV}/${DEV}1 ]
		then
			for PART in `basename  /sys/block/$DEV/$DEV[0-9]*`
			do
				if [ -d /run/media/$PART ]
				then
					echo "Executing bonnie++ on mounted partition, /dev/$PART"
					bonnie++ -u 0 -r 0 -s 64M -d /run/media/$PART
				fi	
			done
		else
			echo "Data partition not found, cannot execute Bonnie++"
		fi
	else
		echo "USB mass storage class device not found, cannot execute Bonnie++"
	fi
done

exit 0

