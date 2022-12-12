#!/bin/bash

# Module to create a ssh key pair for each user

source /opt/redteam-ansible/scripts/colors.sh
banner=('\n\n'
	$RED"██╗   ██╗███████╗███████╗██████╗     ██╗  ██╗███████╗██╗   ██╗ ██████╗ ███████╗███╗   ██╗	\n"$DEF
	$RED"██║   ██║██╔════╝██╔════╝██╔══██╗    ██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝ ██╔════╝████╗  ██║	\n"$DEF
	$RED"██║   ██║███████╗█████╗  ██████╔╝    █████╔╝ █████╗   ╚████╔╝ ██║  ███╗█████╗  ██╔██╗ ██║	\n"$DEF
	$RED"██║   ██║╚════██║██╔══╝  ██╔══██╗    ██╔═██╗ ██╔══╝    ╚██╔╝  ██║   ██║██╔══╝  ██║╚██╗██║	\n"$DEF
	$RED"╚██████╔╝███████║███████╗██║  ██║    ██║  ██╗███████╗   ██║   ╚██████╔╝███████╗██║ ╚████║	\n"$DEF
 	$RED" ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚══════╝╚═╝  ╚═══╝	\n\n"$DEF
	$BLU"	User password and keygen module, causing students pain since 2023. Blame Jarvis		\n\n"$DEF
)

printf "${banner[*]}"
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
			printf $CYN"keys exist for $temp. \n"$DEF;
		else
			printf $BRED"Generating keys for $temp@$Line.\n"$DEF
			ssh-keygen -t rsa -C "$temp@$Line" -f /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp} -P "" &> /dev/null
			mv /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub.normal
			sed -e 's/ /_/g' /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub.normal > /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp}.pub
		fi;
		if [ ! -f /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/password ]; then
			# Add default password of password1!
			printf $BRED"Adding default password of password1!"$DEF
			echo 'password1!' > /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/password
		else
			printf $GRN"password exists for ${temp}: "$DEF
			cat /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/password
		fi;
	done;
done;
