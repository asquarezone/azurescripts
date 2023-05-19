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
RESOURCE_GROUP=$(assign_default_if_empty $2 'mysqlrg')
USER_NAME=$(assign_default_if_empty $3 'qtdevops')
USER_PASSWORD=$(assign_default_if_empty $4 'qthoughtsys@123')
SKU_NAME=$(assign_default_if_empty $5 'Standard_B1ms')

az group create --name $RESOURCE_GROUP --location $LOCATION

az mysql flexible-server create --location $LOCATION \
    --resource-group $RESOURCE_GROUP \
    --sku-name $SKU_NAME \
    --tier Burstable \
    --public-access 0.0.0.0 \
    --name 'qtmysqlflexible'