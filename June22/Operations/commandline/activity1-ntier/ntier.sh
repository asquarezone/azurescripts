#!/bin/bash

resourceGroup='ntier-cli'
location='centralus'
vnetName='ntier'
vnetCidr='10.10.0.0/16'
webCidr='10.10.0.0/24'
businessCidr='10.10.1.0/24'
dataCidr='10.10.2.0/24'

# Create a resource group
#az group create --location $location --name $resourceGroup

# Create a virtual network
az network vnet create --name $vnetName --resource-group $resourceGroup --address-prefixes $vnetCidr 

# Create web subnet
az network vnet subnet create --name 'web' --address-prefixes $webCidr --vnet-name $vnetName --resource-group $resourceGroup

# Create business subnet
az network vnet subnet create --name 'business' --address-prefixes $businessCidr --vnet-name $vnetName --resource-group $resourceGroup

# Create data subnet 
az network vnet subnet create --name 'data' --address-prefixes $dataCidr --vnet-name $vnetName --resource-group $resourceGroup