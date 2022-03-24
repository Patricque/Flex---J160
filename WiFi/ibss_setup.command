#!/bin/bash

# Operator usable ibss.command setup


#Check previous Run state
#If PASS, collect WiFi logs from UUT, then shut the unit down with message for RunIn
#If FAIL, UNTESTED, or INCOMPLETE, collect WiFi logs from UTT, and setup IBSS for retest.


log_store=`/AppleInternal/Diagnostics/Logs/`

#/var/logs/Astro/burnin.astro/log.txt

#LogCollection Function
collectlogs()

{
	cp -r /Phoenix/Logs/WiPAS $log_store
	if [ $? -n 0 ]; then
		echo "Log Collection failed; please check what occurred."
	fi

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
	# Collect Logs anyways; could've failed.
	collectlogs()
	# Run IBSS.
 	/bin/sh /AppleInternal/Applications/WiPAS/WiPASminiOSX.app/Contents/Resources/ibss.command

	#Hides inactive dock items. '-bool false' undoes this change
	#defaults write com.apple.dock static-only -bool true; killall Dock	

	echo ""
	echo "##################"
	echo "ibss.command executed properly."
	echo "##################"
	echo ""

	sleep 5
	killall -c Terminal
	
else
	#Collect UUT WiFi logs and download them to USB
	collectlogs()
	echo "This unit has already PASSED WiFi. Please check the unit status!"
	echo "If this has not PASSED in SFC, please inform your Supervisor."
	echo "The unit will now be powered off in 30s, please stand-by."
	sleep 30
	shutdown -h now
		
fi



