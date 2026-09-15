# Renames a key inside a ConfigMap so the app's expected key disappears
# while the value survives under a new name (easy to overlook in a diff).
# Usage: ./02-configmap-key-rename.sh <namespace> <configmap> <old_key> <new_key>
set -euo pipefail
NS="${1:?namespace required}"
CM="${2:?configmap name required}"
OLD_KEY="${3:?old key required}"
NEW_KEY="${4:?new key required}"

VALUE=$(kubectl get configmap "$CM" -n "$NS" -o jsonpath="{.data.$OLD_KEY}")
kubectl patch configmap "$CM" -n "$NS" --type json -p "[
  {\"op\":\"add\",\"path\":\"/data/$NEW_KEY\",\"value\":\"$VALUE\"},
  {\"op\":\"remove\",\"path\":\"/data/$OLD_KEY\"}
]"
echo "Renamed $OLD_KEY -> $NEW_KEY in configmap $CM ($NS). App still reads $OLD_KEY."
