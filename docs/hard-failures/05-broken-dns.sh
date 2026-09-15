# Simulates broken DNS resolution for one dependency by injecting a bogus
# host alias via a per-pod hostAliases patch pointing the service name at
# an unreachable IP (no cluster-wide CoreDNS edits needed, safer to isolate/revert).
# Usage: ./05-broken-dns.sh <namespace> <deployment> <dependency_service_name>
set -euo pipefail
NS="${1:?namespace required}"
DEPLOY="${2:?deployment name required}"
DEP_SVC="${3:?dependency service name to break, e.g. cinescope-db}"

kubectl patch deployment "$DEPLOY" -n "$NS" --type merge -p "{
  \"spec\":{\"template\":{\"spec\":{\"hostAliases\":[
    {\"ip\":\"127.0.0.1\",\"hostnames\":[\"$DEP_SVC\",\"$DEP_SVC.$NS.svc.cluster.local\"]}
  ]}}}
}"
echo "Injected hostAliases in $DEPLOY ($NS) pointing $DEP_SVC to 127.0.0.1 (DNS effectively broken for it)"
