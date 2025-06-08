import os
import re

# Walk repository and collect lines containing 'IPC' or 'fast bin' mention
TARGET_PATTERNS = [re.compile(rb"\bIPC\b"), re.compile(rb"fast\s*bin", re.I)]

results = []
for root, dirs, files in os.walk('.', followlinks=False):
    for f in files:
        if not f.endswith(('.c', '.h', '.hs', '.lhs')):
            continue
        path = os.path.join(root, f)
        try:
            with open(path, 'rb') as fh:
                for idx, line in enumerate(fh, 1):
                    for pat in TARGET_PATTERNS:
                        if pat.search(line):
                            results.append((path, idx, line.decode('utf-8', 'ignore').rstrip()))
                            break
        except FileNotFoundError:
            continue

for path, line_no, text in results:
    print(f"{path}:{line_no}: {text}")
