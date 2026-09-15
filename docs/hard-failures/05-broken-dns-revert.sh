set -euo pipefail
NS="${1:?namespace required}"
DEPLOY="${2:?deployment name required}"

kubectl patch deployment "$DEPLOY" -n "$NS" --type json -p '[
  {"op":"remove","path":"/spec/template/spec/hostAliases"}
]'
echo "Removed injected hostAliases from $DEPLOY ($NS)"
