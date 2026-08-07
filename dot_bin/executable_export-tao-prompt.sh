#!/usr/bin/env bash
set -euo pipefail

PLANS_DIR="${TAO_PLANS_DIR:-$HOME/.local/share/tao/repos/rollcall-8a39b7dc66e5/plans}"
PROMPTS_DIR="${PROMPTS_DIR:-$(git rev-parse --show-toplevel)/prompts}"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <plan-id>" >&2
  exit 2
fi

plan="$1"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

tao --plans-dir "$PLANS_DIR" report "$plan" --output - > "$tmp"

# Refuse obvious secrets/PII that Tao's sanitizer may have missed (such as SSN filenames).
if grep -En '([[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}|AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|eyJ[[:alnum:]_-]+\.[[:alnum:]_-]+\.|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|(^|[^0-9])[0-9]{9,16}([^0-9]|$))' "$tmp"; then
  echo "Refusing to export: review the possible secret/PII matches above." >&2
  exit 1
fi

# Warn about wording that may have awkward security or process optics.
grep -Eni '(accepted security degradations|risk acceptance by|credential-looking.*commits.*manually|unreviewed direct-to-main|status: changes_requested|changes requested|no review recorded)' "$tmp" >&2 || true

plan_id="$(awk -F ': ' '/^plan-id: / { print $2; exit }' "$tmp")"
title="$(awk '/^# / { sub(/^# /, ""); print; exit }' "$tmp")"
date="${plan_id:0:4}-${plan_id:4:2}-${plan_id:6:2}"
safe_title="$(printf '%s' "$title" | tr '/:' '--' | tr -cd '[:alnum:] ._()&+#-')"
out="$PROMPTS_DIR/$date $safe_title.md"

[[ ! -e "$out" ]] || { echo "Already exists: $out" >&2; exit 1; }
mkdir -p "$PROMPTS_DIR"
mv "$tmp" "$out"
trap - EXIT
printf 'Wrote %s\n' "$out"
