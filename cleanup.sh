#!/bin/bash 

cd terraform/add_new_worker/; terraform destroy -auto-approve
cd ../; terraform destroy -auto-approve
echo "\033[32mAll resources have been deleted\033[0m"