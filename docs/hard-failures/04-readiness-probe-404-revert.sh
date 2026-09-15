set -euo pipefail
NS="${1:?namespace required}"
DEPLOY="${2:?deployment name required}"
ORIGINAL_PATH="${3:?original readiness probe path required, e.g. /healthz}"

kubectl patch deployment "$DEPLOY" -n "$NS" --type json -p "[
  {\"op\":\"replace\",\"path\":\"/spec/template/spec/containers/0/readinessProbe/httpGet/path\",\"value\":\"$ORIGINAL_PATH\"}
]"
echo "Restored readiness probe path to $ORIGINAL_PATH for $DEPLOY ($NS)"
