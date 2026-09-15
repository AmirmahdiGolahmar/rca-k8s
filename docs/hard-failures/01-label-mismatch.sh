# Breaks the Service->Pod selector match by relabeling the deployment's pods.
# Usage: ./01-label-mismatch.sh <namespace> <deployment>
set -euo pipefail
NS="${1:?namespace required}"
DEPLOY="${2:?deployment name required}"

kubectl label deployment "$DEPLOY" -n "$NS" app.kubernetes.io/component=broken --overwrite
kubectl patch deployment "$DEPLOY" -n "$NS" --type merge -p \
  '{"spec":{"template":{"metadata":{"labels":{"app.kubernetes.io/component":"broken"}}}}}'
echo "Injected: pod labels no longer match the Service selector for $DEPLOY in $NS"
