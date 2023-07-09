#!/bin/bash

resource_group_name='workshop1'
primary_vnet_name='ntier-primary'
secondary_vnet_name='ntier-secondary'
primary_location='eastus'
secondary_location='westus'
subnet_name='app'
primary_vnet_cidr='10.0.0.0/16'
secondary_vnet_cidr='10.1.0.0/16'
primary_subnet_cidr='10.0.0.0/24'
secondary_subnet_cidr='10.1.0.0/24'

function create_network_with_subnet() {
    location=$1
    resource_group_name=$2
    vnet_cidr=$3
    vnet_name=$4
    subnet_name=$5
    subnet_cidr=$6

    az network vnet create \
        --location $location \
        --resource-group $resource_group_name \
        --address-prefixes $vnet_cidr \
        --name $vnet_name

    az network vnet subnet create \
        --name $subnet_name \
        --resource-group $resource_group_name \
        --vnet-name $vnet_name \
        --address-prefixes $subnet_cidr

}

# Creates a resource group if it does not exist

if [ $(az group exists --name $resource_group_name) = false ]; then 
   az group create \
    --name $resource_group_name \
    --location $primary_location

    # create a virtual network in primary region
    create_network_with_subnet $primary_location $resource_group_name $primary_vnet_cidr $primary_vnet_name $subnet_name $primary_subnet_cidr

    # Create a virtual network in secondary region
    create_network_with_subnet $secondary_location $resource_group_name $secondary_vnet_cidr $secondary_vnet_name $subnet_name $secondary_subnet_cidr
    
else
   echo "$resource_group_name already exists"
fi




