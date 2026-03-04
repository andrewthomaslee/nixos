# Initialize variables.
REMOTE=$(jq -r '.k3s.init' "$REPO_ROOT"/clan-facts.json)
TOKEN_PATH="$HOME/.kube/tokens"

echo "==> Fetching k3s Token from: $REMOTE"

# Create the directory if it doesn't exist
mkdir -p "$TOKEN_PATH"

# Use the REMOTE variable to rsync
rsync root@"$REMOTE":/var/lib/rancher/k3s/server/token "$TOKEN_PATH/$REMOTE.txt"

echo "==> Token:"
cat "$TOKEN_PATH/$REMOTE.txt"