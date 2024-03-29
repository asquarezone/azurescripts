#!/bin/bash

#./azurevm.sh --group "rg-name" --location "location"

# --group
RESOURCE_GROUP_NAME="fromcli"
# --location
RESOURCE_GROUP_LOCATION="eastus"

# --vnet-name
VIRTUAL_NETWORK_NAME="ntier"
# --vnet-address
VIRTUAL_NETWORK_ADDRESS="10.0.0.0/16"

# --subnet-name
VIRTUAL_NETWORK_SUBNET_NAME="web"
# --subnet-address
VIRTUAL_NETWORK_SUBNET_ADDRESS="10.0.0.0/24"

# --nsg-name
NSG_NAME="webnsg"
# --pip-name
PUBLIC_IP_NAME="webip"
# --pip-sku
PUBLIC_IP_SKU="Standard"
# --pip-allocation
PUBLIC_IP_ALLOCATION="Static"

# --nic-name
NIC_NAME="webnic"

# --vm-name
VM_NAME="web1vm"
# --username
VM_USERNAME="dell"
# --password
VM_PASSWORD="qualitythought@123"
# --vmimage
VM_IMAGE="Ubuntu2204"
# --size
VM_SIZE="Standard_B1s"

# process all arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --group)
            RESOURCE_GROUP_NAME=$2
            shift
            shift
            ;;
        --location)
            RESOURCE_GROUP_LOCATION=$2
            shift
            shift
            ;;
        --vnet-name)
            VIRTUAL_NETWORK_NAME=$2
            shift
            shift
            ;;
        --vnet-address)
            VIRTUAL_NETWORK_ADDRESS=$2
            shift
            shift
            ;;
        --subnet-name)
            VIRTUAL_NETWORK_SUBNET_NAME=$2
            shift
            shift
            ;;
        --subnet-address)
            VIRTUAL_NETWORK_SUBNET_ADDRESS=$2
            shift
            shift
            ;;
        --nsg-name)
            NSG_NAME=$2
            shift
            shift
            ;;
        --pip-name)
            PUBLIC_IP_NAME=$2
            shift
            shift
            ;;
        --pip-sku)
            PUBLIC_IP_SKU=$2
            shift
            shift
            ;;
        --pip-allocation)
            PUBLIC_IP_ALLOCATION=$2
            shift
            shift
            ;;
        --nic-name)
            NIC_NAME=$2
            shift
            shift
            ;;
        --vm-name)
            VM_NAME=$2
            shift
            shift
            ;;
        --username)
            VM_USERNAME=$2
            shift
            shift
            ;;
        --password)
            VM_PASSWORD=$2
            shift
            shift
            ;;
        --vmimage)
            VM_IMAGE=$2
            shift
            shift
            ;;
        --size)
            VM_SIZE=$2
            shift
            shift
            ;;
        *)
        echo azurevm.sh --group "rg-name" --location "location"
        ;;
    esac
done



if [ $(az group exists --name $RESOURCE_GROUP_NAME) = false ]; then 
   # Create Resource Group
    echo "Creating a resource group with name ${RESOURCE_GROUP_NAME} in location ${RESOURCE_GROUP_LOCATION}" 
    az group create \
        --location $RESOURCE_GROUP_LOCATION \
        --name $RESOURCE_GROUP_NAME
else
   echo "$RESOURCE_GROUP_NAME already exists"
fi



# Create a virtual network
# Create a network 
echo "Create a vnet with address ${VIRTUAL_NETWORK_ADDRESS} and name ${VIRTUAL_NETWORK_NAME}"
az network vnet list --output tsv | grep ${VIRTUAL_NETWORK_NAME} -q || az network vnet create \
    --name ${VIRTUAL_NETWORK_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --location $RESOURCE_GROUP_LOCATION \
    --address-prefixes ${VIRTUAL_NETWORK_ADDRESS}

# todo: ensure option is present to create multiple subnets
# Create a subnet
echo "Create a subnet with address ${VIRTUAL_NETWORK_SUBNET_ADDRESS} and name ${VIRTUAL_NETWORK_SUBNET_NAME}"
az network vnet subnet list -g ${RESOURCE_GROUP_NAME} --vnet-name ${VIRTUAL_NETWORK_NAME} --output tsv | grep ${VIRTUAL_NETWORK_SUBNET_NAME} -q || az network vnet subnet create \
    --name ${VIRTUAL_NETWORK_SUBNET_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --vnet-name ${VIRTUAL_NETWORK_NAME} \
    --address-prefixes ${VIRTUAL_NETWORK_SUBNET_ADDRESS}

# Create a network security group
echo "Creating a nsg with name ${NSG_NAME}"
az network nsg list --output tsv | grep ${NSG_NAME} -q || az network nsg create \
    --name ${NSG_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --location $RESOURCE_GROUP_LOCATION 

# Create a rule to open 80 port to every one
echo "Create a rule to open 80 port to every one to ${NSG_NAME}"
az network nsg rule list -g ${RESOURCE_GROUP_NAME} --nsg-name ${NSG_NAME} --output tsv | grep ${NSG_NAME} -q ||az network nsg rule create \
    --name "openhttp" \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --nsg-name ${NSG_NAME} \
    --priority 1000 \
    --access Allow \
    --source-address-prefixes "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "80" \
    --source-port-ranges "*" \
    --direction "Inbound" \
    --protocol "Tcp"

# Create a rule to open 22 port to every one
echo "Create a rule to open 22 port to every one to ${NSG_NAME}"
az network nsg rule list -g ${RESOURCE_GROUP_NAME} --nsg-name ${NSG_NAME} --output tsv | grep ${NSG_NAME} -q || az network nsg rule create \
    --name "openssh" \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --nsg-name ${NSG_NAME} \
    --priority 1100 \
    --access Allow \
    --source-address-prefixes "*" \
    --destination-address-prefixes "*" \
    --destination-port-ranges "22" \
    --source-port-ranges "*" \
    --direction "Inbound" \
    --protocol "Tcp"

# Create a public ip address
echo "Creating public ip"
az network public-ip list --output tsv | grep ${PUBLIC_IP_NAME} -q || az network public-ip create \
    --name ${PUBLIC_IP_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --location $RESOURCE_GROUP_LOCATION \
    --sku ${PUBLIC_IP_SKU} \
    --allocation-method ${PUBLIC_IP_ALLOCATION} 

# Create a network interface
echo "Create a network interface with public ip"
az network nic list --output tsv | grep ${NIC_NAME} -q || az network nic create \
    --name ${NIC_NAME} \
    --resource-group ${RESOURCE_GROUP_NAME} \
    --location $RESOURCE_GROUP_LOCATION \
    --vnet-name $VIRTUAL_NETWORK_NAME \
    --subnet ${VIRTUAL_NETWORK_SUBNET_NAME} \
    --network-security-group ${NSG_NAME} \
    --public-ip-address ${PUBLIC_IP_NAME}


# Create a vm
echo "Creating vm with image ${VM_IMAGE} and size ${VM_SIZE}"
az vm list --output tsv | grep ${VM_NAME} -q || az vm create \
    --name ${VM_NAME} \
     --resource-group ${RESOURCE_GROUP_NAME} \
    --location $RESOURCE_GROUP_LOCATION \
    --admin-password ${VM_PASSWORD} \
    --admin-username ${VM_USERNAME} \
    --nics ${NIC_NAME} \
    --image ${VM_IMAGE} \
    --size ${VM_SIZE}




