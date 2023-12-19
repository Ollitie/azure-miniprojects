// Here you will enter parameters to customize the deployment

using 'main.bicep'

@description('Provide application name. This will be used in resource naming')
param appName = 'testi'

@description('Provide environment: dev / test / prod. This will be used in resource naming')
@allowed([
  'dev'
  'test'
  'prod'
])
param environment = 'dev'

@description('Provide Virtul network name. Suggested format below.')
param vnetName = 'Vnet-${appName}-${environment}'

@description('Provide Vnet address prefix')
param addressPrefix = '10.0.0.0/16'

@description('Provide Subnet name. Suggested format below')
param subnetName = 'Subnet-${appName}-${environment}'

@description('Provide subnet address prefix')
param subnetPrefix = '10.0.1.0/24'

@description('Which IP addressess should be created?')
@allowed([
  'private'
  'privateAndPublic'
])
param ipAddresses = 'private'

@description('Provide virtual machine count')
param vmCount = 2

@description('Provide virtual machine size')
@allowed([
  'Standard_B1s'
  'Standard_B2s'
  'Standard_D2s_V3'
])
param vmSize = 'Standard_B1s'

@description('Choose the desired Ubuntu image')
@allowed([
  'Ubuntu-1804'
  'Ubuntu-2004'
  'Ubuntu-2204'
])
param ubuntuOSVersion = 'Ubuntu-2004'

@description('Choose the authentication type to use on the Virtual Machine.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType = 'password'

@description('Enter admin username on the Virtual Machines(s).')
param adminUsername = 'azureuser'
