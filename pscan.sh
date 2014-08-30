#!/bin/bash

clear
echo -e "\nPlease select your option :"
echo -e "\n1. Internal scan"
echo -e "2. External scan"
echo -e "3. Quit"
echo -ne "\nOption > "
read option

case $option in
	"1")	ip_add=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -v "127.0.0.1" | cut -d: -f2`;;
	"2")	ip_add=`curl ipecho.net/plain --silent`;;
	"3")	exit;;
	*)		ip_add="ERROR";;
esac

clear
echo -ne "\n[+] Fetching your IP address : "
sleep 1
echo $ip_add
net_ip=`echo $ip_add | cut -d. -f1,2,3`
sleep 1
echo -e "\n[+] Scanning the network\n"
if [[ $# -eq 1 ]]
then
	proxy="proxychains"
fi

for i in {1..254}
do
	$proxy ping -w 2 $net_ip.$i &> /dev/null
	if [ $? -eq 0 ]
	then
		echo "$ip_add.$i : Host is up"
	fi
	sleep 1
done