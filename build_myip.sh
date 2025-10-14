#!/usr/bin/env bash
set -euo pipefail

# build_myip.sh - create an executable named "myip" from myip.py located in the same directory

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src="$script_dir/myip.py"
out="$script_dir/myip"

if [ ! -f "$src" ]; then
  echo "Error: '$src' not found." >&2
  exit 2
fi

# Write a portable python3 shebang, then append the Python source.
printf '%s\n' '#!/usr/bin/env python3' > "$out"

# If the source already has a shebang, skip its first line to avoid duplicate.
if head -n 1 "$src" | grep -q '^#!'; then
  tail -n +2 "$src" >> "$out"
else
  cat "$src" >> "$out"
fi

chmod +x "$out"
printf 'Created executable: %s\n' "$out"