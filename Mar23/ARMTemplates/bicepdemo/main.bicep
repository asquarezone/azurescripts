@description('This is region')
param region string = resourceGroup().location

@description('vnet address space')
param vnetAddressSpace string = '10.0.0.0/16'

param subnets array = ['10.0.0.0/24','10.0.1.0/24', '10.0.2.0/24']

var vnetName = 'ntier'

resource ntiervnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: vnetName
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: [ vnetAddressSpace ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: subnets[0]
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: subnets[1]
        }
      }
      {
        name: 'Subnet-3'
        properties: {
          addressPrefix: subnets[2]
        }
      }
    ]
  }
}

output test string = ntiervnet.id

