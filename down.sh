export NAME=kubeflow
export RESOURCE_GROUP_NAME=kubeflow
export LOCATION=ukwest
export RESOURCE_GROUP_NAME_MACHINES=MC_${RESOURCE_GROUP_NAME}_${NAME}_${LOCATION}

az login
az group delete --name $RESOURCE_GROUP_NAME_MACHINES --yes
az group delete --name $RESOURCE_GROUP_NAME --yes

# az aks delete --name $NAME --resource-group $RESOURCE_GROUP_NAME --no-wait --yes
# ^ doesn't work for some reason! meh... deleting resource groups seems fine... some other rainy day!