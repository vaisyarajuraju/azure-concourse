#!/bin/bash
set -e


if [ $arg_wipe == "wipe" ];
        then
                echo "Wiping Environment...."
        else
                echo "Need Args [0]=wipe, anything else and I swear I'll exit and do nothing!!! "
                echo "Example: ./wipe-env.sh wipe ..."
                exit 0
fi

azure login --service-principal -u 62d3ce6c-f8f8-48c5-ab17-f89e63807add -p PCF@123dellemc --tenant 6b40e4ac-4a61-4eb5-9eb9-e14838500e18


if [[ ! -z ${azure_multi_resgroup_pcf} && ${azure_pcf_terraform_template} == "c0-azure-multi-res-group" ]]; then
    azure_terraform_prefix=${azure_multi_resgroup_pcf}
fi

# Test if Resource Group exists,  if so then wipe it!!!
get_res_group_cmd="azure group list --json | jq '.[] | select(.name == \"${azure_terraform_prefix}\") | .' | jq .name | tr -d '\"'"
get_res_group=$(eval ${get_res_group_cmd})
if [[ ${get_res_group} = ${azure_terraform_prefix} ]]; then
    echo "Found Resource Group to Remove ....."
    azure group delete --subscription 992dff24-5a8a-4cf3-8701-353c7c22a2fb --name ${azure_terraform_prefix} --quiet
fi
