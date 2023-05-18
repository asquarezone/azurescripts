#!/bin/bash
assign_default_if_empty() {
    value=$1
    default=$2
    if [[ -z $value ]]; then
        echo $default
    else
        echo $value
    fi
}


LOCATION=$(assign_default_if_empty $1 'eastus')
RESOURCE_GROUP=$(assign_default_if_empty $2 'fromcli')
SERVER_NAME=$(assign_default_if_empty $3 'qtactivityscriptsrv')
DB_NAME=$(assign_default_if_empty $4 'erpdb')
COMPUTE_MODEL=$(assign_default_if_empty $5 'Provisioned')
EDITION=$(assign_default_if_empty $6 'Basic')
START_IP=$(assign_default_if_empty $7 '0.0.0.0')
END_IP=$(assign_default_if_empty $8 '255.255.255.255')


echo "Creating a azure sql database with following details"
echo "LOCATION ==> ${LOCATION}"
echo "Resource Group  ==> ${RESOURCE_GROUP}"
echo "Server Name ==> ${SERVER_NAME}"
echo "Database Name ==> ${DB_NAME}"

# Create a resource group if it doesnot exists
GROUP_EXISTS=$(az group exists -n ${RESOURCE_GROUP})
echo $GROUP_EXISTS
if [[ $GROUP_EXISTS == 'true' ]]; then
    echo "Group already exists"
else
    echo "Group doesnot exist need to create"
    az group create --name ${RESOURCE_GROUP} --location ${LOCATION}
    echo "Resource group ${RESOURCE_GROUP} created"
fi


SERVER_EXISTS=$(az sql server list -g 'fromcli' --query "length([?name=='qtactivityscriptsrv'])")

if [[ $SERVER_EXISTS == "1" ]]; then
    echo "Server with ${SERVER_NAME} already exists"
else
    # Create a server
    az sql server create \
        --name  ${SERVER_NAME} \
        --location ${LOCATION} \
        --resource-group ${RESOURCE_GROUP} \
        --admin-user 'qtdevops' \
        --admin-password 'motherindia@123' \
        --enable-public-network true --identity-type UserAssigned
fi


# Create a firewall rule (openall)
az sql server firewall-rule create \
    --name 'openall' \
    --resource-group ${RESOURCE_GROUP} \
    --server ${SERVER_NAME} \
    --start-ip-address ${START_IP} \
    --end-ip-address ${END_IP}

az sql db create \
    --name ${DB_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --server ${SERVER_NAME} \
    --compute-model ${COMPUTE_MODEL} \
    --edition ${EDITION} \
    --sample-name 'AdventureWorksLT'