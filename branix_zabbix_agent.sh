#!/bin/bash
# Usage example: ./branix_zabbix_agent.sh 

#################################################### CONFIGURATION ###
BUILD=202303161
PASS=$(openssl rand -base64 32|sha256sum|base64|head -c 18| tr '[:upper:]' '[:lower:]')
DBPASS=$(openssl rand -base64 24|sha256sum|base64|head -c 8| tr '[:upper:]' '[:lower:]')

####################################################   CLI TOOLS   ###
reset=$(tput sgr0)
bold=$(tput bold)
underline=$(tput smul)
black=$(tput setaf 0)
white=$(tput setaf 7)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
bgblack=$(tput setab 0)
bgwhite=$(tput setab 7)
bgred=$(tput setab 1)
bggreen=$(tput setab 2)
bgyellow=$(tput setab 4)
bgblue=$(tput setab 4)
bgpurple=$(tput setab 5)

#################################################### SETUP ######

# LOGO
clear
echo "${green}${bold}"
echo ""
echo "█████╗ ██████╗  █████╗ ███╗   ██╗██╗██╗  ██╗ ";
echo "██╔══██╗██╔══██╗██╔══██╗████╗  ██║██║╚██╗██╔╝";
echo "██████╔╝██████╔╝███████║██╔██╗ ██║██║ ╚███╔╝ ";
echo "██╔══██╗██╔══██╗██╔══██║██║╚██╗██║██║ ██╔██╗ ";
echo "██████╔╝██║  ██║██║  ██║██║ ╚████║██║██╔╝ ██╗";
echo "╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝";
echo "                                                          ";
echo " With great power comes great responsibility... "
echo ""
echo "Installation has been started... Hold on!"
echo "${reset}"
sleep 3s


# OS CHECK
clear
clear
echo "${bggreen}${black}${bold}"
echo "OS check..."
echo "${reset}"
sleep 1s

ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
VERSION=$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')

if [ "$ID" = "ubuntu" ]; then

    case $VERSION in
        20.04)
            break
            ;;
		 22.04)
            break
            ;;
        *)
            echo "${bgred}${white}${bold}"
            echo "Requires Ubuntu 20.04 LTS or latter"
            echo "${reset}"
            exit 1;
            break
            ;;
    esac

else
    echo "${bgred}${white}${bold}"
    echo "Requires Linux Ubuntu 20.04 LTS or latter"
    echo "${reset}"
    exit 1
fi


# ROOT CHECK
clear
clear
echo "${bggreen}${black}${bold}"
echo "Permission check..."
echo "${reset}"
sleep 1s

if [ "$(id -u)" = "0" ]; then
    clear
else
    clear
    echo "${bgred}${white}${bold}"
    echo "You have to run as root. (In AWS use 'sudo -s')"
    echo "${reset}"
    exit 1
fi

# GET IP
clear
clear
echo "${bggreen}${black}${bold}"
echo "Getting IP..."
echo "${reset}"
sleep 1s

IP=$(curl -s https://checkip.amazonaws.com)

# BASIC SETUP
clear
clear
echo "${bggreen}${black}${bold}"
echo "Zabbix Agent setup..."
echo "${reset}"
sleep 1s

sudo apt update
sudo apt -y install zabbix-agent
service zabbix-agent restart



