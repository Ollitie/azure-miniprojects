// This main.bicep file and its modules create a desired amount of Virtual Machines
// ..along with other needed resources such as. vnet, subnet, nsg, nics and public ips
// Parameters can be customized in the parameters file


param location string = resourceGroup().location
param appName string
param environment string
param vnetName string
param addressPrefix string
param subnetName string
param subnetPrefix string
param nsgName string = format('NSG-${appName}-${environment}')
param vmCount int
param vmSize string
param ubuntuOSVersion string
param authenticationType string
param adminUsername string
@secure()
param adminPasswordOrKey string
param ipAddresses string



module vnet 'network.bicep' = {
  name: 'vnetModule'
  params: {
    location: location
    vnetName: vnetName
    addressPrefix: addressPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    nsgName: nsgName
  }
}


module vm 'virtualmachine.bicep' = {
  name: 'vmModule'
  params: {
    appName: appName
    location: location
    vmCount: vmCount
    vmSize: vmSize
    ipAddresses: ipAddresses
    environment: environment
    vnetName: vnetName
    subnetName: subnetName
    ubuntuOSVersion: ubuntuOSVersion
    authenticationType: authenticationType
    adminUsername: adminUsername
    adminPasswordOrKey: adminPasswordOrKey
  }
  dependsOn: [
    vnet
  ]
}
