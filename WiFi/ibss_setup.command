#!/bin/bash

# Operator usable ibss.command setup

#Check previous Run state
#If PASS, collect WiFi logs from UUT, then shut the unit down with message for RunIn
#If FAIL, UNTESTED, or INCOMPLETE, collect WiFi logs from UTT, and setup IBSS for retest.
#Need to ensure that use in IO1 doesn't break the system

#UUT Store
mkdir /AppleInternal/Diagnostics/Logs/WiPAS_Logs
log_store="/AppleInternal/Diagnostics/Logs/WiPAS_Logs/"

#LogCollection Function
#Works: F5KHH03CK7GF - RUNIN 3/31/22 @ 7:19
collectlogs()

{

cp -r /Phoenix/Logs/WiPAS $log_store
if [ $? != 0 ]; then
	echo "Log Collection failed; please check what occurred."
fi	

}


ibss_setup()

{

/AppleInternal/Applications/WiPAS/WiPASminiOSX.app/Contents/Resources/ibss.command

}



main()
{
#CB Check
cb_check=`/usr/local/bin/eos-ssh controlbits read --offset 0xC1 | awk -F"|" '{print $2}' | grep -c "PASS"`

if [ $cb_check -ne 1 ]; then
	echo "This unit has no pass record."
	echo "Setting up for WiFi testing..."
	echo ""
	echo "##################"
	echo "Running ibss.command..."
	echo "##################"
	echo ""
	# Collect Logs anyways; could've failed.
	collectlogs
	# Run IBSS.
	ibss_setup
	echo ""
	echo "##################"
	echo "ibss.command executed properly."
	echo "##################"
	echo ""	
else
      #Collect UUT WiFi logs and download them to USB
	collectlogs
	
	echo -e "\n\033[34m====================================\033[00m\033[37m"
	echo -e "\033[42m  ██████╗  █████╗ ███████╗███████╗  \033[00m\033[37m"
	echo -e "\033[42m  ██╔══██╗██╔══██╗██╔════╝██╔════╝  \033[00m\033[37m"
	echo -e "\033[42m  ██████╔╝███████║███████╗███████╗  \033[00m\033[37m"
	echo -e "\033[42m  ██╔═══╝ ██╔══██║╚════██║╚════██║  \033[00m\033[37m"
	echo -e "\033[42m  ██║     ██║  ██║███████║███████║  \033[00m\033[37m"
	echo -e "\033[42m  ╚═╝     ╚═╝  ╚═╝╚══════╝╚══════╝  \033[00m\033[37m"
	echo -e "\033[34m====================================\033[00m\033[37m"
    	
    	echo -e "\nThis unit has already PASSED WiFi. Please check the unit status!"
	echo -e "If this has not PASSED in SFC, please inform your Supervisor.\n"
	echo -e "The unit will now be powered off in 30s, please stand-by.\n"
	sleep 10
	shutdown -h now
		
fi
}

main
