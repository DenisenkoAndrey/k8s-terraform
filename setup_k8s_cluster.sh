#!/bin/bash /usr/bin/virsh

if grep -wq "terraformmaster_1" ansible/playbooks/hosts; then
   > /dev/null    
else
  echo "\033[31mCheck the inventory file - hosts in masters group\033[0m"; exit
fi
if grep -wq "terraformworker_1" ansible/playbooks/hosts; then
   > /dev/null    
else
   echo "\033[31mCheck the inventory file - hosts in workers group\033[0m"; exit
fi

while true; do
  read -p "Do you have terraform mirror installed(y/n)? " yn
  case $yn in
    [Yy]* ) if [ ! -f $HOME/.terraformrc ]; then
	      echo "\033[31mYou do not have terraform mirror installed! Try again and say: no!\033[0m"; exit 
            fi
        cd terraform/; terraform init
            if [ $? != 0 ]; then
        echo "\033[31mCheck the .terraformrc file!\033[0m"; exit
            fi
        terraform apply && cd ../ansible/playbooks || exit
            if ping -c2 192.168.100.101 && ping -c2 192.168.100.102 && echo "\033[32mPing successful\033[0m"; then
        ansible-playbook k8s_dependencies.yml setup_masters.yml setup_workers.yml
      
echo "\033[32mYou are welcome! K8s cluster is ready!
Now you have at least two (three) running VMs:\033[0m
"

virsh net-dhcp-leases k8s_terraform

echo "\033[34musername: andrey
password: 12345\033[0m
"

echo "\033[31mTo delete all resources use:
cleanup.sh script\033[0m"
            else
echo "\033[31mPlease check the inventory file - hosts\033[0m"; 
            fi; break;;

    [Nn]* ) if [ -f $HOME/.terraformrc ]; then
        cd terraform/; terraform init
            if [ $? != 0 ]; then
        echo "\033[31mYou already have the .terraformrc file!. Check its contents!\033[0m"; exit
            fi
        terraform apply && cd ../ansible/playbooks || exit
            if ping -c2 192.168.100.101 && ping -c2 192.168.100.102 && echo "\033[32mPing successful\033[0m"; then
        ansible-playbook k8s_dependencies.yml setup_masters.yml setup_workers.yml

echo "\033[32mYou are welcome! K8s cluster is ready!
Now you have at least two (three) running VMs:\033[0m
"

virsh net-dhcp-leases k8s_terraform

echo "\033[34musername: andrey
password: 12345\033[0m
"

echo "\033[31mTo delete all resources use:
cleanup.sh script\033[0m"; exit 
            else
echo "\033[31mPlease check the inventory file - hosts\033[0m"; exit 
            fi
            else
        cat terraform_mirror.txt > $HOME/.terraformrc
	      cd terraform/; terraform init
        terraform apply && cd ../ansible/playbooks || exit
            if ping -c2 192.168.100.101 && ping -c2 192.168.100.102 && echo "\033[32mPing successful\033[0m"; then
        ansible-playbook k8s_dependencies.yml setup_masters.yml setup_workers.yml

echo "\033[32mYou are welcome! K8s cluster is ready!
Now you have at least two (three) running VMs:\033[0m
"

virsh net-dhcp-leases k8s_terraform

echo "\033[34musername: andrey
password: 12345\033[0m
"

echo "\033[31mTo delete all resources use:
cleanup.sh script\033[0m"; 
         else
echo "\033[31mPlease check the inventory file - hosts\033[0m";
         fi; fi; break;;

    * ) echo "invalid input";;
  esac
done