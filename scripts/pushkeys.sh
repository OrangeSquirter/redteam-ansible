#!/bin/bash

# push public keys to authorized keys if it does not exist

USER=$1
PUBKEY=$2


sed -e 's/ /_/g' "/home/$USER/.ssh/authorized_keys" > "/home/$USER/.ssh/authorized_keys.tmp"
if grep -q "$PUBKEY" "/home/$USER/.ssh/authorized_keys.tmp";
then
	:
else
	echo "$PUBKEY" > "/home/$USER/.ssh/authorized_keys.tmp"
	sed -e 's/_/ /g' "/home/$USER/.ssh/authorized_keys.tmp" >> "/home/$USER/.ssh/authorized_keys"
fi
rm -f "/home/$USER/.ssh/authorized_keys.tmp"
