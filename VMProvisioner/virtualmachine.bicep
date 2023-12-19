// Module to provision a desired number of virtual machines, along with attached nics and public ips.
// VM count, size, Ubuntu version and authentication type can be chosen in the parameters file.
// Module uses loops to create multiple resources and some conditional expressions.

param appName string
param environment string
param location string
param vmCount int
param vmSize string
param vnetName string
param subnetName string
param ubuntuOSVersion string
param authenticationType string
param adminUsername string
@secure()
param adminPasswordOrKey string
param ipAddresses string

var nicCount = vmCount
var pipCount = vmCount
var vmName = format('VM-${appName}-${environment}')
var imageReference = {
  'Ubuntu-1804': {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2004': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}
var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2022-09-01' = [for i in range(0, pipCount): if (ipAddresses == 'privateAndPublic') {
  name: format('pip-${appName}-${environment}-{0}', i)
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
    idleTimeoutInMinutes: 4
  }
}]


resource nics 'Microsoft.Network/networkInterfaces@2022-09-01' = [for i in range(0, nicCount): {
  name: format('nic-${appName}-${environment}-{0}', i)
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: ((ipAddresses == 'private') ? null : {
            id: publicIPAddress[i].id
          })
        }
      }
    ]
  }
}]


resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = [for i in range(0, vmCount): {
  name: format('${vmName}-{0}', i)
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: imageReference[ubuntuOSVersion]
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
        }
      ]
    }
    osProfile: {
      computerName: format('${vmName}-{0}', i)
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
  }
}]
