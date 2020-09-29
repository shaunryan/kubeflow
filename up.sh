export KFTAR=https://github.com/kubeflow/kfctl/releases/download/v1.1.0/kfctl_v1.1.0-0-g9a3621e_darwin.tar.gz
export KFTAR_NAME=kfctl.tar.gz
export RESOURCE_GROUP_NAME=kubeflow
export LOCATION=ukwest
export NAME=kubeflow
export AGENT_SIZE=Standard_D4s_v3
export AGENT_COUNT=2
export LOCATION=ukwest

# Set KF_NAME to the name of your Kubeflow deployment. This also becomes the
# name of the directory containing your configuration.
# For example, your deployment name can be 'my-kubeflow' or 'kf-test'.
export KF_NAME=kubeflow
# The following command is optional, to make kfctl binary easier to use.
export PATH=$PATH:$PWD
# Set the path to the base directory where you want to store one or more 
# Kubeflow deployments. For example, /opt/.
# Then set the Kubeflow application directory for this deployment.
export BASE_DIR=${PWD}/opt
export KF_DIR=${BASE_DIR}/${KF_NAME}
# Set the configuration file to use, such as the file specified below:
export CONFIG_URI="https://raw.githubusercontent.com/kubeflow/manifests/v1.1-branch/kfdef/kfctl_k8s_istio.v1.1.0.yaml"
export KFCTL=${PWD}/bin/kfctl

az login
az group create -n $RESOURCE_GROUP_NAME -l $LOCATION
az aks create -g $RESOURCE_GROUP_NAME -n $NAME -s $AGENT_SIZE -c $AGENT_COUNT -l $LOCATION --generate-ssh-keys
az aks get-credentials -n $NAME -g $RESOURCE_GROUP_NAME --overwrite-existing

if [[ ! -d $KF_DIR ]]; then
    mkdir bin
    cd bin
    wget -cO - $KFTAR > $KFTAR_NAME
    tar -xvf $KFTAR_NAME
    rm kfctl.tar.gz
    chmod +x kfctl
    mkdir opt
    mkdir -p ${KF_DIR}
fi

# Generate and deploy Kubeflow:
cd ${KF_DIR}
$KFCTL apply -V -f ${CONFIG_URI}

kubectl get all -n $KF_NAME

kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80