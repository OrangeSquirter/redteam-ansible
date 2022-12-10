#!/bin/bash

ListOfTargets=/opt/redteam-ansible/inventory/teams
Lines=$(cat $ListOfTargets)
for Line in $Lines;
do
	Users=$(cat /opt/redteam-ansible/inventory/users/${Line})
	for User in $Users;
	do
		temp="$(echo "$User"|tr -d '\n')"
		ansible-playbook /opt/redteam-ansible/playbooks/usercheck/usercheck.yaml -i /opt/redteam-ansible/inventory/hosts --ask-become-pass --extra-vars "variable_hosts=${Line} variable_user=${temp}";
	done;
done;
