set -euo pipefail
NS="${1:?namespace required}"
DEPLOY="${2:?deployment name required}"
ORIGINAL_VALUE="${3:?original label value required, e.g. $DEPLOY}"

kubectl patch deployment "$DEPLOY" -n "$NS" --type merge -p \
  "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"app.kubernetes.io/component\":\"$ORIGINAL_VALUE\"}}}}}"
echo "Reverted labels for $DEPLOY in $NS"
