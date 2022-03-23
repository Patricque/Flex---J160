#!/bin/bash

# Operator usable ibss.command setup


#Check previous Run state
#If PASS, collect WiFi logs from UUT, then shut the unit down with message for RunIn
#If INCOMPLETE, collect WiFI logs from UTT, and setup IBSS for retest
#IF FAIL, collect Wifi logs from UUT and setup IBSS for retest so it can fail out for UOP

#LogCollection Function
collectlogs()

{




}


#CB Check
cb_check=`usr/local/bin/eos-ssh controlbits read --offset 0xC1 | awk -F"|" '{print $2}' | grep -c "PASS"`

if [ $cb_check -ne 1 ]; then
	echo "This unit has no pass record."
	echo "Setting up for WiFi testing..."
	echo ""
	echo "##################"
	echo "Running ibss.command..."
	echo "##################"
	echo ""



 	/bin/sh /AppleInternal/Applications/WiPAS/WiPASminiOSX.app/Contents/Resources/ibss.command

	if [ $? -ne 0 ]; then
	
		#Hides inactive dock items. '-bool false' undoes this change
		defaults write com.apple.dock static-only -bool true; killall Dock
	
		else
		echo ""
		echo "##################"
		echo "ibss.command executed properly."
		echo "##################"
		echo ""
	fi

	sleep 5
	killall -c Terminal
else
	#Collect UUT WiFi logs and download them to USB
		
fi
//
#Invoke IBSS

echo ""
echo "##################"
echo "Running ibss.command..."
echo "##################"
echo ""


/bin/sh /AppleInternal/Applications/WiPAS/WiPASminiOSX.app/Contents/Resources/ibss.command

if [ $? -ne 0 ]; then
	
	#Hides inactive dock items. '-bool false' undoes this change
	defaults write com.apple.dock static-only -bool true; killall Dock
	
	else
	echo ""
	echo "##################"
	echo "ibss.command executed properly."
	echo "##################"
	echo ""
fi

sleep 5
killall -c Terminal
//



