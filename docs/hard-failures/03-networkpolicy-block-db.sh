# Adds a default-deny-ish NetworkPolicy on the DB pods that only allows
# traffic from a label nothing actually has, silently cutting off the app.
# Usage: ./03-networkpolicy-block-db.sh <namespace> <db_label_selector_value>
set -euo pipefail
NS="${1:?namespace required}"
DB_LABEL="${2:?value of app label on the db pods, e.g. cinescope-db}"

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: rca-injected-block-db
  namespace: $NS
spec:
  podSelector:
    matchLabels:
      app: $DB_LABEL
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: nothing-has-this-label
EOF
echo "Injected NetworkPolicy rca-injected-block-db in $NS, blocking ingress to app=$DB_LABEL"
