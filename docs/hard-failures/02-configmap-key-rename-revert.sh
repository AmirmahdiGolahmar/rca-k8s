set -euo pipefail
NS="${1:?namespace required}"
CM="${2:?configmap name required}"
OLD_KEY="${3:?old key required}"
NEW_KEY="${4:?new key required}"

VALUE=$(kubectl get configmap "$CM" -n "$NS" -o jsonpath="{.data.$NEW_KEY}")
kubectl patch configmap "$CM" -n "$NS" --type json -p "[
  {\"op\":\"add\",\"path\":\"/data/$OLD_KEY\",\"value\":\"$VALUE\"},
  {\"op\":\"remove\",\"path\":\"/data/$NEW_KEY\"}
]"
echo "Reverted $NEW_KEY -> $OLD_KEY in configmap $CM ($NS)"
