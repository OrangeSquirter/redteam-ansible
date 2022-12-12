#!/bin/bash
source /opt/redteam-ansible/scripts/colors.sh
banner=('\n\n'
	$RED"██╗   ██╗███████╗███████╗██████╗      ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗\n"$DEF
	$RED"██║   ██║██╔════╝██╔════╝██╔══██╗    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝\n"$DEF
	$RED"██║   ██║███████╗█████╗  ██████╔╝    ██║     ███████║█████╗  ██║     █████╔╝ \n"$DEF
	$RED"██║   ██║╚════██║██╔══╝  ██╔══██╗    ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ \n"$DEF
	$RED"╚██████╔╝███████║███████╗██║  ██║    ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗\n"$DEF
 	$RED" ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝     ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝\n"$DEF
)
printf "${banner[*]}"
ListOfTargets=/opt/redteam-ansible/inventory/teams
Lines=$(cat $ListOfTargets)
for Line in $Lines;
do
	Users=$(cat /opt/redteam-ansible/inventory/users/${Line}/${Line})
	for User in $Users;
	do
		temp="$(echo "$User"|tr -d '\n')"
		temp="$(echo "$temp"|tr -d \'\")"
		if [ ${temp} != "root" ]; then
			userpass=$(<"/opt/redteam-ansible/inventory/users/$Line/keys/$temp/password")
			printf "$userpass \n"
			ansible-playbook /opt/redteam-ansible/playbooks/usercheck/usercheck.yaml -e ansible_become_password=${userpass} -i /opt/redteam-ansible/inventory/hosts  --key-file /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp} --extra-vars "variable_hosts=${Line} variable_user=${temp}";
		fi;
	done;
done;
