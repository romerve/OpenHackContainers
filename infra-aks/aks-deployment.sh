# Create Resource Group
az group create -l EastUS -n aks-clusters-rg

# Deploy template with in-line parameters
az deployment group create -g aks-clusters-rg  --template-uri https://github.com/Azure/AKS-Construction/releases/download/0.9.14/main.json --parameters \
	resourceName=kslo-dev \
	managedNodeResourceGroup=NaN \
	kubernetesVersion=1.26.3 \
	agentCount=2 \
	upgradeChannel=stable \
	agentVMSize=Standard_D4ds_v5 \
	nodePoolName=npapps \
	agentCountMax=3 \
	custom_vnet=true \
	serviceCidr=10.100.4.0/22 \
	dnsServiceIP=10.100.4.10 \
	vnetAddressPrefix=10.100.0.0/20 \
	vnetAksSubnetAddressPrefix=10.100.0.0/22 \
	enableTelemetry=false \
	omsagent=true \
	retentionInDays=30 \
	azurepolicy=audit \
	cniDynamicIpAllocation=true \
	podCidr=10.100.7.0/22 \
	maxPods=250 \
	keyVaultAksCSI=true \
	keyVaultCreate=true \
	keyVaultOfficerRolePrincipalId=$(az ad signed-in-user show --query id --out tsv) \
	fluxGitOpsAddon=true \
	containerLogsV2BasicLogs=true \
	enableSysLog=true

# Get credentials for your new AKS cluster & login (interactive)
az aks get-credentials -g aks-clusters-rg -n aks-kslo-dev
kubectl get nodes

# Deploy charts into cluster
curl -sL https://github.com/Azure/AKS-Construction/releases/download/0.9.14/postdeploy.sh  | bash -s -- -r https://github.com/Azure/AKS-Construction/releases/download/0.9.14 \
	-p containerLogsV2=true