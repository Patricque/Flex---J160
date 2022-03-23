# Scan_For_Bad_HDMI.sh
# Version 1.5
# Scan for bad HDMI for all found GPUs and all active DP heads to catch issues like Radar 58225599 & 58044201

/bin/echo "Check For Bad Madea HDMI in TMDS mode..."
numberGPUs=`/AppleInternal/AppleGraphicsControl/dpdump -l | grep -c "AppleGraphicsDevicePolicy"`
/usr/bin/printf 'Found %u GPUs\n' $numberGPUs

if [ -z $numberGPUs ];then
	exit 0
else
	for (( gpuNum=1; gpuNum<=$numberGPUs; gpuNum++))
	do
		theNode=`/AppleInternal/AppleGraphicsControl/dpdump -l | grep "AppleGraphicsDevicePolicy" | head -"$gpuNum" | tail -1 | awk -F'[][]' '{print$2}'`
		if [ -n $theNode ];then
			badHDMIcount=`/AppleInternal/AppleGraphicsControl/dpdump -n $theNode -S 2>/dev/null | grep -c "device present  \[TMDS\]"`
			if [ $badHDMIcount -gt 0 ]; then
				/bin/echo "Found BAD HDMI similar to Radar 58225599 & 58044201"
				/AppleInternal/AppleGraphicsControl/dpdump -n $theNode -S
				/bin/echo "Dumping Slot0 GPIO Expander Pin State"
				/usr/local/bin/smcif -w SMBC 0x01 0x03 0x44 0x00 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
				/usr/local/bin/smcif -w SMBC 0x01 0x03 0x44 0x01 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
				/usr/local/bin/smcif -w SMBC 0x01 0x03 0x44 0x02 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
				/bin/echo "Dumping Slot2 GPIO Expander Pin State"
				/usr/local/bin/smcif -w SMBC 0x01 0x04 0x44 0x00 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
				/usr/local/bin/smcif -w SMBC 0x01 0x04 0x44 0x01 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
				/usr/local/bin/smcif -w SMBC 0x01 0x04 0x44 0x02 0x00 0x01; /usr/local/bin/smcif -w SMBG 1; /usr/local/bin/smcif -r SMBS; /usr/local/bin/smcif -r SMBR;
				exit 1
			fi
		fi
	done
fi
/bin/echo "No BAD displays found"
exit 0
