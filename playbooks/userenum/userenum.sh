#!/bin/bash
source /opt/redteam-ansible/scripts/colors.sh
banner=(''
	'\n\n'
	$RED'██╗   ██╗███████╗███████╗██████╗     ███████╗███╗   ██╗██╗   ██╗███╗   ███╗███████╗██████╗  █████╗ ████████╗██╗ ██████╗ ███╗   ██╗\n'$DEF
	$RED'██║   ██║██╔════╝██╔════╝██╔══██╗    ██╔════╝████╗  ██║██║   ██║████╗ ████║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║\n'$DEF
	$RED'██║   ██║███████╗█████╗  ██████╔╝    █████╗  ██╔██╗ ██║██║   ██║██╔████╔██║█████╗  ██████╔╝███████║   ██║   ██║██║   ██║██╔██╗ ██║\n'$DEF
	$RED'██║   ██║╚════██║██╔══╝  ██╔══██╗    ██╔══╝  ██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══╝  ██╔══██╗██╔══██║   ██║   ██║██║   ██║██║╚██╗██║\n'$DEF
	$RED'╚██████╔╝███████║███████╗██║  ██║    ███████╗██║ ╚████║╚██████╔╝██║ ╚═╝ ██║███████╗██║  ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║\n'$DEF
	$RED' ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ \n\n\n'$DEF
)
ListOfTargets=/opt/redteam-ansible/inventory/teams
Lines=$(cat $ListOfTargets)
printf "${banner[*]}"
for Line in $Lines;
do	
	ansible-playbook /opt/redteam-ansible/playbooks/userenum/userenum.yaml -i /opt/redteam-ansible/inventory/hosts --extra-vars "variable_hosts=${Line}" >> /opt/redteam-ansible/inventory/users/${Line}/${Line}.tmp;
done;
# Filter out anything that is not a username
for Line in $Lines;
do
	grep -ho 'home/[^" ]\+' /opt/redteam-ansible/inventory/users/${Line}/${Line}.tmp | cut -d- -f2 | sort -u >> /opt/redteam-ansible/inventory/users/${Line}/${Line};
	sed -i -e 's/home\/\|\\//g' /opt/redteam-ansible/inventory/users/${Line}/${Line}
	awk -i inplace '!seen[$0]++' /opt/redteam-ansible/inventory/users/${Line}/${Line}
done

