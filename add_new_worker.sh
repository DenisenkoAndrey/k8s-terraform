#!/bin/bash 

if grep -wq "terraform_new_worker_1" ansible/playbooks/hosts; then
   > /dev/null    
else
   echo "\033[31mCheck the inventory file - hosts in add_new_workers group\033[0m"; exit
fi
if ping -c2 192.168.100.101 && echo "\033[32mPing successful\033[0m"; then
   > /dev/null 
else
   echo "\033[31mThe master is unreachable or does not exist! Use setup_k8s_cluster.sh script\033[0m"; exit
fi
if nc -zvw3 192.168.100.101 6443; then
   echo "\033[32mConnection to 192.168.100.101 6443 port [tcp/*] succeeded!\033[0m"
else
   echo "\033[31mPort 6443 is closed! Connection refused!\033[0m"; exit
fi
   cd terraform/add_new_worker/; terraform init
        if [ $? != 0 ]; then 
   echo "\033[31mCheck the .terraformrc file!\033[0m"; exit
        else
   terraform apply && (echo "\033[32mPlease, wait a minute! The VM installation is being completed\033[0m"; sleep 60) || exit
        fi
   cd ../../ansible/playbooks; ansible-playbook add_new_worker.yml  
echo "\033[32mTerraform_new_worker_1 added!\033[0m
"

virsh net-dhcp-leases k8s_terraform

echo "\033[34musername: andrey
password: 12345\033[0m
"

echo "\033[31mTo delete all resources use:
cleanup.sh script\033[0m"