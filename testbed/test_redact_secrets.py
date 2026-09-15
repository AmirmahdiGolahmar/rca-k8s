import json
import subprocess

CASES = [
    ("kubectl describe secret output with DB_PASSWORD (should BLOCK, exit 2)",
     {"tool_name": "Bash", "tool_response": {"stdout": "DB_PASSWORD=Sup3rSecretXyz123"}}),
    ("AWS access key leaked in a log line (should BLOCK, exit 2)",
     {"tool_name": "Bash", "tool_response": {"stdout": "creds: AKIAABCDEFGHIJKLMNOP"}}),
    ("private key block in output (should BLOCK, exit 2)",
     {"tool_name": "Bash", "tool_response": {"stdout": "-----BEGIN RSA PRIVATE KEY-----\nMIIB..."}}),
    ("benign pod list output (should ALLOW, exit 0)",
     {"tool_name": "Bash", "tool_response": {"stdout": "NAME  READY  STATUS\nnginx-test  1/1  Running"}}),
    ("source code reading env var via os.environ.get (should ALLOW, exit 0 - no false positive)",
     {"tool_name": "Bash", "tool_response": {"stdout": 'db_password = os.environ.get("DB_PASSWORD")'}}),
    ("source code reading env var via getenv (should ALLOW, exit 0 - no false positive)",
     {"tool_name": "Bash", "tool_response": {"stdout": "token = getenv('TOKEN')"}}),
    ("source code attribute assignment via a function call (should ALLOW, exit 0 - no false positive)",
     {"tool_name": "Bash", "tool_response": {"stdout": "self.secret_key = generate_key()"}}),
    ("dotted literal secret e.g. JWT-shaped value (should still BLOCK, exit 2)",
     {"tool_name": "Bash", "tool_response": {"stdout": "auth_token=eyJhbGc.eyJzdWIi.SflKxw"}}),
    ("plain literal password value (should still BLOCK, exit 2)",
     {"tool_name": "Bash", "tool_response": {"stdout": "password: hunter2222"}}),
]

for desc, payload in CASES:
    proc = subprocess.run(
        ["python3", "hooks/scripts/redact-secrets.py"],
        input=json.dumps(payload), capture_output=True, text=True,
    )
    print(f"--- {desc} ---")
    print("exit code:", proc.returncode)
    if proc.stderr.strip():
        print("stderr:", proc.stderr.strip())
    print()
