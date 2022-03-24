#!/bin/bash

# Operator usable ibss.command setup


#Check previous Run state
#If PASS, collect WiFi logs from UUT, then shut the unit down with message for RunIn
#If FAIL, UNTESTED, or INCOMPLETE, collect WiFi logs from UTT, and setup IBSS for retest.


log_store="/AppleInternal/Diagnostics/Logs/"


#CB Check
cb_check=`/usr/local/bin/eos-ssh controlbits read --offset 0xC1 | awk -F"|" '{print $2}' | grep -c "PASS"`
if [ "$cb_check" -ne 1 ]; then
   echo "This unit has no pass record."
   echo "Setting up for WiFi testing..."
   echo ""
   echo "##################"
   echo "Running ibss.command..."
   echo "##################"
   echo ""
   #Collect Logs anyways; could've failed.
   cp -r /Phoenix/Logs/WiPAS $log_store
   if [ $? -ne 0 ]; then
      echo -e "\nLog collect failed."
   else
      echo -e "\nLogs collected and moved to '$log_store'"
   fi
   #Run IBSS
   #/AppleInternal/Applications/WiPAS/WiPASminiOSX.app/Contents/Resources/ibss.command
   echo ""
   echo "##################"
   echo "ibss.command executed properly."
   echo "##################"
   echo " "

	#sleep 5
	#killall -c Terminal

else
	#Collect UUT WiFi logs and download them to USB
      cp -r /Phoenix/Logs/WiPAS $log_store
      if [ $? -ne 0 ]; then
         echo -e "\nLog collect failed."
      else
         echo -e "\nLogs collected and moved to '$log_store'"
      fi
	echo ""
        echo "This unit has already PASSED WiFi. Please check the unit status!"
	echo "If this has not PASSED in SFC, please inform your Supervisor."
	
	echo -e "Resetting Astro, as well, for a clean start\n"
	/usr/local/bin/eos-ssh astro reset

	echo ""
	echo "The unit will now be powered off in 30s, please stand-by."
	echo ""
	sleep 30
	shutdown -h now
		
fi


