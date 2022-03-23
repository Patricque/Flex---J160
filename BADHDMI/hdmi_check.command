#!/bin/bash


pid=$$
date_time=$(date '+%Y_%m_%d__%H_%M_%S')
date_date=$(date '+%Y_%m_%d')
mkdir /Users/Patricque/Desktop/EmulatorCheck/ &> /dev/null
mkdir /Users/Patricque/Desktop/EmulatorCheck/${date_date} &> /dev/null
mkdir /Users/Patricque/Desktop/EmulatorCheck/${date_date}/${pid}

echo -e "Input the number of loops you'd like to run:"
read loops

until [ $loops = 0 ] 
do 

	system_profiler SPDisplaysDataType | grep "HDMI2K" -A 9 > /Users/Patricque/Desktop/EmulatorCheck/${date_date}/${pid}/HDMI_log.txt
	file_name=/Users/Patricque/Desktop/EmulatorCheck/${date_date}/${pid}/HDMI_log.txt
	#For Pass instances; never test one without the other
	#echo "Pass" > $file_name
	date_time=$(date '+%Y_%m_%d__%H_%M_%S')
	if [ -s $file_name ]; then
		echo ""
		echo "##################"
		echo "There is an HDMI Emultor installed."
		echo "##################"
		echo ""
		status_1="Pass"
		newfile="${file_name}_${status_1}_${loops}_${date_time}_${pid}.txt"
		mv -v -n $file_name $newfile
		

	else
		echo ""
		echo "##################"
		echo "The file is empty; please check that the emulator is installed."
		echo "But, just in case, we will now scan for Bad HDMIs."	
		echo "##################"
		echo ""
		status_1="Fail"
		newfile="${file_name}_${status_1}_${loops}_${date_time}_${pid}.txt"
		mv -v -n $file_name $newfile
		/Users/Patricque/Desktop/Debug/BADHDMI/Scan_For_Bad_HDMI.sh > $newfile
		echo "######## Failed Loop#: $loops ########" >> $newfile

	fi
let "loops-=1"	
done