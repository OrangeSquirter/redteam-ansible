#!/bin/bash

ListOfTargets=/opt/redteam-ansible/inventory/teams
Lines=$(cat $ListOfTargets)
for Line in $Lines;
do
        Users=$(cat /opt/redteam-ansible/inventory/users/${Line}/${Line})
        for User in $Users;
        do
		temp="$(echo "$User"|tr -d '\n')"
                temp="$(echo "$temp"|tr -d \'\")"
		userkey=$(<"/opt/redteam-ansible/inventory/users/$Line/keys/$temp/$temp.pub")
                ansible-playbook /opt/redteam-ansible/playbooks/pushpubkeys/pushpubkeys.yaml -i /opt/redteam-ansible/inventory/hosts --extra-vars "variable_hosts=${Line} variable_user=${temp} variable_key=${userkey}";
	done;
done;
