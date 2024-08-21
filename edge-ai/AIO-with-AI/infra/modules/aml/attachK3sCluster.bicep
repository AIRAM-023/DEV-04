/*region Header
      Module Steps 
      1 - Attach a Kubernetes cluster to Azure Machine Learning workspace

      //https://learn.microsoft.com/en-us/azure/machine-learning/how-to-attach-kubernetes-to-workspace
*/

//Declare Parameters--------------------------------------------------------------------------------------------------------------------------
param location string
param resourceGroupName string
param amlworkspaceName string
param arcK8sClusterName string
param vmUserAssignedIdentityID string


//Using Azure CLI
resource attachK3sCluster 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'attachK3sCluster'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${vmUserAssignedIdentityID}': {}
    }
  }
  properties: {
    azCliVersion: '2.52.0'
    scriptContent: loadTextContent('../../../scripts/azd_attachK3sCluster.sh')
    retentionInterval: 'PT1H'
    cleanupPreference: 'OnSuccess'
    timeout: 'PT1H'
    forceUpdateTag: 'v1'
    environmentVariables: [
      {
        name: 'resourceGroupName'
        value: resourceGroupName
      }
      {
        name: 'amlworkspaceName'
        value: amlworkspaceName
      }
      {
        name: 'arcK8sClusterName'
        value: arcK8sClusterName
      }
      {
        name: 'vmUserAssignedIdentityID'
        value: vmUserAssignedIdentityID
      }
      {
        name: 'subscription'
        value: subscription().subscriptionId
      }

    ]
  }
}
