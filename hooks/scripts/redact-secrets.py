#!/usr/bin/env python3
import datetime
import json
import os
import re
import sys

data = json.load(sys.stdin)

SECRET_PATTERNS = [
    (r"AKIA[0-9A-Z]{16}", "AWS access key"),
    (r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----", "private key block"),
    (
        # Excludes values shaped like a function call / attribute access
        # (os.environ.get(...), getenv(...), self.secret_key = gen()) so that
        # source code *declaring how to read* a secret isn't itself flagged —
        # only values that look like an actual literal are.
        r"(?i)\b[a-z0-9_]*(password|passwd|secret|api[_-]?key|token)[a-z0-9_]*"
        r"\s*[:=]\s*(?!['\"]?[a-z_][a-z0-9_.]*\s*\()"
        r"['\"]?[^\s'\"]{4,}",
        "key=value secret-like assignment",
    ),
]

# Scan the whole tool_response regardless of its exact shape (string, dict,
# list) by dumping it back to text — robust to differences across tools.
blob = json.dumps(data.get("tool_response", ""), default=str)

for pattern, label in SECRET_PATTERNS:
    if re.search(pattern, blob):
        log_path = os.path.join(os.path.dirname(__file__), "..", "logs", "redactions.log")
        os.makedirs(os.path.dirname(log_path), exist_ok=True)
        with open(log_path, "a") as f:
            f.write(
                f"{datetime.datetime.now(datetime.timezone.utc).isoformat()} "
                f"tool={data.get('tool_name')} matched={label}\n"
            )
        print(
            f"Blocked: tool output matched a secret-like pattern ({label}). "
            "Withheld from context to avoid leaking a credential value.",
            file=sys.stderr,
        )
        sys.exit(2)

sys.exit(0)
