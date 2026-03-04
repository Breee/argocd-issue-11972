
# create a kind cluster
kind create cluster --name argocd-issue-11972 --kubeconfig ~/.kube/argocd-issue-11972-config --config kind-cluster-with-extramounts.yaml
export KUBECONFIG=~/.kube/argocd-issue-11972-config

# install argocd using helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd --create-namespace --wait

# Enable the experimental Cluster topology feature for docker provider
export CLUSTER_TOPOLOGY=true
clusterctl init --infrastructure docker --kubeconfig ~/.kube/argocd-issue-11972-config

clusterctl generate cluster capi-quickstart --flavor development \
  --kubernetes-version v1.35.0 \
  --control-plane-machine-count=1 \
  --worker-machine-count=1 \
  > capi-quickstart.yaml