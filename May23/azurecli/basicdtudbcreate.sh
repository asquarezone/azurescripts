#!/bin/bash
LOCATION='eastus'
RESOURCE_GROUP='fromcli'
SERVER_NAME='qtactivityscriptsrv'
DB_NAME='erpdb'
COMPUTE_MODEL='Provisioned'
EDITION='Basic'
START_IP='0.0.0.0'
END_IP='255.255.255.255'


echo "Creating a azure sql database with following details"
echo "LOCATION ==> ${LOCATION}"
echo "Resource Group  ==> ${RESOURCE_GROUP}"
echo "Server Name ==> ${SERVER_NAME}"
echo "Database Name ==> ${DB_NAME}"

# Create a resource group

az group create --name ${RESOURCE_GROUP} --location ${LOCATION}
echo "Resource group ${RESOURCE_GROUP} created"
# Create a server
az sql server create \
    --name  ${SERVER_NAME} \
    --location ${LOCATION} \
    --resource-group ${RESOURCE_GROUP} \
    --admin-user 'qtdevops' \
    --admin-password 'motherindia@123' \
    --enable-public-network true --identity-type UserAssigned


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