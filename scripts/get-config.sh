REMOTE=$1

echo "==> Fetching kubeconfig from $REMOTE . . ."

# Fetch kubeconfig
rsync "root@$REMOTE:/etc/rancher/k3s/k3s.yaml" "$KUBECONFIG"

sed -i "s/: default/: k3s/g" "$KUBECONFIG"

# Set the correct server address
kubectl --kubeconfig="$KUBECONFIG" config set-cluster k3s --server="https://kube-api-clan-net:6443"
chmod 660 "$KUBECONFIG"

echo "✅ Done!"