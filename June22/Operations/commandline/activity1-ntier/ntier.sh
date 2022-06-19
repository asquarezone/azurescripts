#!/bin/bash

resourceGroup='ntier-cli'
location='centralus'
vnetName='ntier'
vnetCidr='10.10.0.0/16'
webCidr='10.10.0.0/24'
businessCidr='10.10.1.0/24'
dataCidr='10.10.2.0/24'

# This script will delete the resource group if it exists

if [ $(az group exists --name $resourceGroup) = true ]; then
    echo "Resourcegroup $resourceGroup in region $location already exists, so recreating"
    az group delete --name $resourceGroup -y
else
    echo "Resourcegroup $resourceGroup in region $location does not exists, so creating"
fi

# Create a resource group
az group create --location $location --name $resourceGroup

echo "Created resourcegroup $resourceGroup in region $location"

# Create a virtual network
az network vnet create --name $vnetName --resource-group $resourceGroup --address-prefixes $vnetCidr 

# Create web subnet
az network vnet subnet create --name 'web' --address-prefixes $webCidr --vnet-name $vnetName --resource-group $resourceGroup

# Create business subnet
az network vnet subnet create --name 'business' --address-prefixes $businessCidr --vnet-name $vnetName --resource-group $resourceGroup

# Create data subnet 
az network vnet subnet create --name 'data' --address-prefixes $dataCidr --vnet-name $vnetName --resource-group $resourceGroup
