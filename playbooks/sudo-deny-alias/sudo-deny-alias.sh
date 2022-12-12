#!/bin/bash
source /opt/redteam-ansible/scripts/colors.sh
banner=('\n\n'
        $RED"███████╗██╗   ██╗██████╗  ██████╗     ████████╗██████╗  ██████╗ ██╗     ██╗     \n"$DEF
	$RED"██╔════╝██║   ██║██╔══██╗██╔═══██╗    ╚══██╔══╝██╔══██╗██╔═══██╗██║     ██║     \n"$DEF
	$RED"███████╗██║   ██║██║  ██║██║   ██║       ██║   ██████╔╝██║   ██║██║     ██║     \n"$DEF
	$RED"╚════██║██║   ██║██║  ██║██║   ██║       ██║   ██╔══██╗██║   ██║██║     ██║     \n"$DEF
	$RED"███████║╚██████╔╝██████╔╝╚██████╔╝       ██║   ██║  ██║╚██████╔╝███████╗███████╗\n"$DEF
	$RED"╚══════╝ ╚═════╝ ╚═════╝  ╚═════╝        ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝\n"$DEF      
)
printf "${banner[*]}"
PLAYBOOKNAME=sudo-deny-alias
ListOfTargets=/opt/redteam-ansible/inventory/teams
Lines=$(cat $ListOfTargets)
#This module should only be executed as root
USER=root
for Line in $Lines;
do
        ansible-playbook /opt/redteam-ansible/playbooks/$PLAYBOOKNAME/$PLAYBOOKNAME.yaml --key-file /opt/redteam-ansible/inventory/users/${Line}/keys/$USER/$USER -i /opt/redteam-ansible/inventory/hosts --extra-vars "variable_hosts=${Line} variable_user=${USER}";
done;
for Line in $Lines;
do
        Users=$(cat /opt/redteam-ansible/inventory/users/${Line}/${Line})
        for User in $Users;
        do
                temp="$(echo "$User"|tr -d '\n')"
                temp="$(echo "$temp"|tr -d \'\")"
                userkey=$(<"/opt/redteam-ansible/inventory/users/$Line/keys/$temp/$temp.pub")
                userpass=$(<"/opt/redteam-ansible/inventory/users/$Line/keys/$temp/password")
                ansible-playbook /opt/redteam-ansible/playbooks/$PLAYBOOKNAME/$PLAYBOOKNAME.yaml -e ansible_password=${userpass} -e ansible_become_password=${userpass} --key-file /opt/redteam-ansible/inventory/users/${Line}/keys/${temp}/${temp} -i /opt/redteam-ansible/inventory/hosts --extra-vars "variable_hosts=${Line} variable_user=${temp}";
        done;
done;
