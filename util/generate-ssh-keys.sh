#!/bin/bash

# Module to create a ssh key pair for each user

ListOfTargets=/opt/redteam-ansible/inventory/teams
Lines=$(cat $ListOfTargets)
for Line in $Lines;
do
	mkdir /opt/redteam-ansible/inventory/users/${Line}/keys &> /dev/null
        Users=$(cat /opt/redteam-ansible/inventory/users/${Line}/${Line})
        for User in $Users;
        do
                temp="$(echo "$User"|tr -d '\n')"
                temp="$(echo "$temp"|tr -d \'\")"
		mkdir /opt/redteam-ansible/inventory/users/${Line}/keys/${temp} &> /dev/null
		if test -f "/opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}"; then
			printf "keys exist for $temp. \n";
		else
			printf "Generating keys for $temp@$Line.\n"
			ssh-keygen -t rsa -C "$temp@$Line" -f /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp} -P "" &> /dev/null
			mv /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub.normal
			sed -e 's/ /_/g' /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub.normal > /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub
		fi;
		if [ ! -f /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/password ]; then
			# Add default password of password1!
			echo "Adding default password of password1!"
			echo 'password1!' > /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/password
		else
			echo "password exists for ${temp}: "
			cat /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/password
		fi;
	done;
done;
