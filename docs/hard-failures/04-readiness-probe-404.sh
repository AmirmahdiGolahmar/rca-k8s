# Points the readiness probe at a path that 404s, so the pod runs fine but
# never becomes Ready / never receives traffic.
# Usage: ./04-readiness-probe-404.sh <namespace> <deployment> <container_name>
set -euo pipefail
NS="${1:?namespace required}"
DEPLOY="${2:?deployment name required}"
CONTAINER="${3:?container name required}"

kubectl patch deployment "$DEPLOY" -n "$NS" --type json -p "[
  {\"op\":\"replace\",\"path\":\"/spec/template/spec/containers/0/readinessProbe/httpGet/path\",\"value\":\"/this-path-does-not-exist\"}
]"
echo "Readiness probe for $CONTAINER in $DEPLOY ($NS) now points at a 404 path"
