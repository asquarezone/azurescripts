#!/bin/bash
# Usage create_subnet 'ApplicationGatewaySubnet' 'ntiervnet' 'fromcli' '172.16.0.0/24'

create_subnet() {
    subnet_name=$1
    vnet_name=$2
    rg_name=$3
    subnet_address_prefix=$4
    az network vnet subnet create --address-prefixes "$4" --resource-group '$3' --vnet-name '$2' --name '$1'

}

# Create a resource group
az group create --location eastus --name 'fromcli'

# Create a virtual network
az network vnet create --name 'winntier' --resource-group 'fromcli' --address-prefixes "172.16.0.0/16"

# Create subnets
# Application Gateway Subnet
create_subnet 'ApplicationGatewaySubnet' 'ntiervnet' 'fromcli' '172.16.0.0/24'
# Management Subnet
create_subnet 'ManagmentSubnet' 'ntiervnet' 'fromcli' '172.16.1.0/24'

# Webtier Subnet
create_subnet 'Webtier' 'ntiervnet' 'fromcli' '172.16.2.0/24'

# Business Tier
create_subnet 'Businesstier' 'ntiervnet' 'fromcli' '172.16.3.0/24'

# DataTier
create_subnet 'Datatier' 'ntiervnet' 'fromcli' '172.16.4.0/24'

# ActiveDirectory Subnet
create_subnet 'ActiveDirectorySubnet' 'ntiervnet' 'fromcli' '172.16.5.0/24'

# Application Gateway network security group
az network nsg create --name 'ApplicationGatewaynsg' --resource-group 'fromcli'
# Allow 80 and 443 ports from any where
az network nsg rule create --name 'Allow http and https' --nsg-name 'ApplicationGatewaynsg' --resource-group 'fromcli' --priority 300 --access Allow --source-address-prefixes '*' --source-port-ranges '*' --destination-port-ranges 80 443 --direction 'Inbound' --protocol 'TCP'

# Management subnet networks security group
az network nsg create --name 'Managementnsg' --resource-group 'fromcli'

# Allow 22 and 3389 port from any where
az network nsg rule create --name 'Allow ssh and rdp' --nsg-name 'Managementnsg'  --resource-group 'fromcli'  --priority 300 --access Allow --source-address-prefixes '*' --source-port-ranges '*' --destination-port-ranges 22 3389 --direction 'Inbound' --protocol 'TCP'