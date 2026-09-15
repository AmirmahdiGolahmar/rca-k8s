---
name: k8s-rca
description: Use whenever asked to find the root cause of a broken/misbehaving workload in a Kubernetes namespace (crash loops, pending pods, failed requests, etc). Enforces a fixed read-only diagnostic order before any hypothesis is proposed.
---

# Kubernetes Root Cause Analysis

Follow this order. Do not skip a step or jump to a hypothesis early — each step
narrows what the next step should look for.

1. **Pods** — `kubectl get pods -n <ns> -o wide`
   Note: Restarts, Status (CrashLoopBackOff, Pending, ImagePullBackOff...), Age.

2. **Events** — `kubectl get events -n <ns> --sort-by=.lastTimestamp`
   Look for scheduling failures, OOMKills, pull errors, probe failures near the
   pod's last restart time.

3. **Describe** — `kubectl describe pod <pod> -n <ns>`
   Check: container statuses, last termination reason, resource requests/limits,
   volume mounts, node events.

4. **Logs** — `kubectl logs <pod> -n <ns>` and, if it has restarted,
   `kubectl logs <pod> -n <ns> --previous`.
   The previous-container log is often the only place the real crash reason shows.

5. **Relevant YAML** — `kubectl get deployment <name> -n <ns> -o yaml`
   (or statefulset/daemonset). Cross-check env vars, image tag, resources,
   volumes against what logs/events pointed to.

6. **Endpoints** — `kubectl get endpoints <service> -n <ns>`
   If a Service has no endpoints, the selector/label doesn't match — this catches
   the "healthy pods, unreachable service" class of bug that logs alone won't show.

7. **Only now: hypothesize** and write the `PROPOSED PATCH` in `CLAUDE.md`'s
   required format. If steps 1–6 didn't produce a clear cause, say so — do not
   guess.

## Common trap

A single suspicious log line is not a root cause. Confirm it against events and
the deployment spec before committing to it in EVIDENCE.
