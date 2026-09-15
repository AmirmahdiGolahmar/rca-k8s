set -euo pipefail
NS="${1:?namespace required}"
kubectl delete networkpolicy rca-injected-block-db -n "$NS" --ignore-not-found
echo "Removed rca-injected-block-db from $NS"
