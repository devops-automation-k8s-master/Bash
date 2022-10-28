#!/bin/bash

source /etc/esh/esh.conf
serverCachePath="/etc/esh/cachedServerDetails"

function sshExecution()
{
  fileName="$pemFolderPath/${pemFileName}"
  ssh -i $fileName ${userName}@${serverIP}
}

function accessOnEC2()
{
  serverDetails=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${serverName}"\
   --query Reservations[*].Instances[*][KeyName,PublicIpAddress,PrivateIpAddress]\
    --output=text)
  if [[ -z $serverDetails ]]
  then
    echo "Something is wrong, Please check AWS credential or check serverName"
    exit 1
  fi
}

function cacheServer()
{
  ls $serverCachePath | grep -q $serverName
  echo $?
}

while getopts :p:u:i:n:hcvl opt
do
  case $opt in
  c)
    rm -rf $serverCachePath/*
    echo "Cached, ServerDetails Deleted."
    exit 1
    ;;
  v)
    echo -e "Version=0.1\nMaintainer=DevOpsTeam"
    exit 1
    ;;
  l)
    ls $serverCachePath
    exit 1
    ;;
  u)
    userName=$OPTARG
    ;;
  n)
    serverName=$OPTARG
    echo $serverName
    ;;
  p)
    pemFileName=$OPTARG
    ;;
  i)
    serverIP=$OPTARG
  ;;
  ?)
    echo -e "             -c: Clear Cached server information.\n\
             -h: For help.\n\
             -i: Public ip address of the server.\n\
             -l: List All cached server information.\n\
             -n: Name of Server.If you know the name of server then do Not need to use -p and -i option.\n\
             -p: Name of Pem File.\n\
             -u:By Default user is ubuntu,If you want to set user then use this argument.Example: -u username\n\
             -v: Version of esh.\n\
             Note: If you are using ipaddress, then pem file name must be use in argument."

esac
done
if [[ -z "$userName" ]]
then
  userName=ubuntu
fi

if [[ -n "$serverName" ]]
then
  declare -ag array=()
  status=$(cacheServer)

  if [[ $status -ne 0 ]]
  then
    echo "accessing on ec2"
    accessOnEC2
    touch $serverName
    echo "$serverDetails">"$serverCachePath/$serverName"
  else
    echo "serverdetails is available in cached"
    serverDetails=$(cat "$serverCachePath/$serverName"  )
  fi

  i=0
  for elem in $serverDetails
  do
    array[$i]="$elem"
    ((i=i+1))
  done

  if [[ -z "$pemFileName" ]]
    then
      pemFileName="${array[0]}.pem"
      echo $pemFileName
  fi

  if [[ -z "$serverIP" ]]
  then
    serverIP=${array[1]}
    if [[ "$serverIP" == "None" ]]
      then
        serverIP=${array[2]}
    fi
  fi
  sshExecution

elif [[ -n "$serverIP" ]]  && [[ -n "$pemFileName" ]]
then
  sshExecution
else
    echo "Please use -h for help"
fi
