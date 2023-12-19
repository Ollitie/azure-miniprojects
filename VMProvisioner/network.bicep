// Network module that creates a virtual network, subnet and calls for network security group module
// Parameters can be customized in the parameters file

param location string
param vnetName string
param addressPrefix string
param subnetName string
param subnetPrefix string
param nsgName string



module nsg 'networksecuritygroup.bicep' = {
  name: 'nsgModule'
  params: {
    location: location
    nsgName: nsgName
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          networkSecurityGroup: {
            id: nsg.outputs.nsgId
          }
        }
      }
    ]
  }
  dependsOn: [
    nsg
  ]
}
