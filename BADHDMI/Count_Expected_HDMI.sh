# Count_Expected_HDMI.sh
# Version 1.5
# Scan for connected Displays and verify the count is not less than the number of expected HDMI to catch issues like Radar 58225599 & 58044201
# Don't fail if we find more than the expected number of Displays so we don't false fail when someone has connected a display for debugging -- this could mask a failure but a debug display should be connected rarely

expectedHDMI=$1
if [ -z $expectedHDMI ];then
	/bin/echo "Need to specify a parameter for number of expected HDMIs"
	exit 1
fi
/usr/bin/printf 'Searching for %u HDMI dongles in Runin...\n' $expectedHDMI

numberGPUs=`/AppleInternal/AppleGraphicsControl/dpdump -l | grep -c "AppleGraphicsDevicePolicy"`
/usr/bin/printf 'Found %u GPUs\n' $numberGPUs

if [ -z $numberGPUs ];then
	/AppleInternal/AppleGraphicsControl/dpdump -l
	/bin/echo "Failed to find GPUs" 
	exit 2
else
	countedHDMI=0
	for (( gpuNum=1; gpuNum<=$numberGPUs; gpuNum++))
	do
		theNode=`/AppleInternal/AppleGraphicsControl/dpdump -l | grep "AppleGraphicsDevicePolicy" | head -"$gpuNum" | tail -1 | awk -F'[][]' '{print$2}'`
		if [ -n $theNode ];then
			HDMIcount=`/AppleInternal/AppleGraphicsControl/dpdump -n $theNode -S 2>/dev/null | grep -c "4 x HBR2 : status: 7777"`
			countedHDMI=$((countedHDMI + HDMIcount))
		fi
	done
	if [ $countedHDMI -lt $expectedHDMI ]; then
        /bin/echo "*** Found fewer HBR2 x4 Displays than expected, an HDMI dongle may be missing or there may be a hardware issue ***"
		for (( gpuNum=1; gpuNum<=$numberGPUs; gpuNum++))
		do
			theNode=`/AppleInternal/AppleGraphicsControl/dpdump -l | grep "AppleGraphicsDevicePolicy" | head -"$gpuNum" | tail -1 | awk -F'[][]' '{print$2}'`
			if [ -n $theNode ];then
				/AppleInternal/AppleGraphicsControl/dpdump -n $theNode -S 
			fi
		done
		/bin/echo "Dumping Slot0 GPIO Expander Pin State"
		/usr/local/bin/smcif -w SMBC 0x01 0x03 0x44 0x00 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
		/usr/local/bin/smcif -w SMBC 0x01 0x03 0x44 0x01 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
		/usr/local/bin/smcif -w SMBC 0x01 0x03 0x44 0x02 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
		/bin/echo "Dumping Slot2 GPIO Expander Pin State"
		/usr/local/bin/smcif -w SMBC 0x01 0x04 0x44 0x00 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
		/usr/local/bin/smcif -w SMBC 0x01 0x04 0x44 0x01 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
		/usr/local/bin/smcif -w SMBC 0x01 0x04 0x44 0x02 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
		exit 3
	elif [ $countedHDMI -gt $expectedHDMI ]; then
        /usr/bin/printf '*** WARNING: Found a greater number of Displays connected %u, than expected -- if an extra display is not connected for debug purposes there could be a hardware issue\n' $countedHDMI
    else
        /bin/echo "Found at least the expected number of HBR2 x4 Displays connected"
    fi
fi

#for (( gpuNum=1; gpuNum<=$numberGPUs; gpuNum++))
#do
#    theNode=`/AppleInternal/AppleGraphicsControl/dpdump -l | grep "AppleGraphicsDevicePolicy" | head -"$gpuNum" | tail -1 | awk -F'[][]' '{print$2}'`
#    if [ -n $theNode ];then
#        /AppleInternal/AppleGraphicsControl/dpdump -n $theNode -S
#    fi
#done

exit 0
