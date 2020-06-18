#!/bin/bash
set -ex

echo "Install Ansible / Ansible lint"
sudo pip install -U pip
pip install ansible ansible-lint

echo "Install Tflint"
curl -L https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | sudo bash

echo "========================================="
echo "Packer validation"
echo "========================================="
find packer/ -name '*.json' -not -name "variables.json" -print \
-exec packer validate -var-file='./packer/variables.json.example' {} \;
echo "=========================================\n\n"

echo "========================================="
echo "Terraform validation & tflint"
echo "========================================="
find terraform/ -type f -name 'main.tf' -not -path "*/\.*" \
 | sed 's#/[^/]*$##' \
 | sort -u \
 | xargs -I {} sh -c "cd ${PWD}/{}; echo '$PWD/{}'; terraform init > /dev/null; terraform validate; tflint" \;
echo "=========================================\n\n"

echo "========================================="
echo "Ansible lint"
echo "========================================="
find ansible/playbooks -type f -name '*.yml' -exec ansible-lint {} \;
echo "========================================="
