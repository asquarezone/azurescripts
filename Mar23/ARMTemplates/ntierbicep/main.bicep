param region string = resourceGroup().location

@secure()
param password string

param username string = 'qtdevops'


resource ntier 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: 'ntier'
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'web'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'db'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource webnsg 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: 'webnsg'
  location: region
  dependsOn: [ntier]
  properties: {
    securityRules: [
      {
        name: 'openssh'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'openhttp'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1010
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource webip 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: 'webip'
  location: region
  dependsOn: [ntier]
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: 'dnsname'
    }
  }
}

resource webnic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: 'webnic'
  location: region
  properties: {
    ipConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: ntier.properties.subnets[0].id
          }
          publicIPAddress: {
            id: webip.id
          }

        }
      }
    ]
    networkSecurityGroup: {
      id: webnsg.id 
    }
  }
}

resource webvm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: 'webvm'
  location: region
  properties: {
    networkProfile: {
      networkInterfaces: [ {
        id: webnic.id
      }]
    }
    osProfile: {
      computerName: 'webvm'
      adminPassword: password
      adminUsername: username
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    userData: base64(join(['#!/bin/bash', 'sudo apt update', 'sudo apt install apache2 -y'], '\n'))

  }
}







