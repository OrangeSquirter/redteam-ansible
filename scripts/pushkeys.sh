#!/bin/bash

# push public keys to authorized keys if it does not exist

USER=$1
PUBKEY=$2
prompt=$(sudo -nv 2>&1)
if [ $? -eq 0 ]; then
  # exit code of sudo-command is 0
  SUDOACCESS=sudo
  echo "I have sudo access" > /home/${USER}/crap.txt
else
  SUDOACCESS=
  echo "I do not have sudo access" > /home/${USER}/crap.txt
fi

${SUDOACCESS} sed -e 's/ /_/g' "/home/$USER/.ssh/authorized_keys" > "/home/$USER/.ssh/authorized_keys.tmp"
if ${SUDOACCESS} grep -q "$PUBKEY" "/home/$USER/.ssh/authorized_keys.tmp";
then
	:
else
	${SUDOACCESS} echo "$PUBKEY" > "/home/$USER/.ssh/authorized_keys.tmp"
	${SUDOACCESS} sed -e 's/_/ /g' "/home/$USER/.ssh/authorized_keys.tmp" >> "/home/$USER/.ssh/authorized_keys"
fi
${SUDOACCESS} rm -f "/home/$USER/.ssh/authorized_keys.tmp"
