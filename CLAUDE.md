## Namespace

- Test namespace: rca-test

## Services & topology

- rca-test (python:3.11-slim, port 8080), Service rca-test-svc
- No downstream dependency — single deployment, self-contained
- Reads APP_GREETING from configmap rca-test-config, DB_PASSWORD from
  secret rca-test-secret
- Exposes /healthz for readiness/liveness

## Where logs & metrics live

- Pod logs only: kubectl logs / kubectl logs --previous
- Events: kubectl get events -n rca-test --sort-by=.lastTimestamp

## Required answer format

ROOT CAUSE: <...>

EVIDENCE:

- <...> -> <...>

CONFIDENCE: high | medium | low

PROPOSED PATCH:
<yaml>
