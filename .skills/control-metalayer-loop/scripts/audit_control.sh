#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: audit_control.sh [repo_path] [--strict]

Audit repository for control metalayer artifacts.
USAGE
}

repo_path="."
strict=0

while [ $# -gt 0 ]; do
  case "$1" in
    --strict)
      strict=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [ "$repo_path" != "." ]; then
        echo "error: multiple repo paths provided" >&2
        exit 1
      fi
      repo_path="$1"
      ;;
  esac
  shift
done

if [ ! -d "$repo_path" ]; then
  echo "error: repo path not found: $repo_path" >&2
  exit 1
fi

repo_path=$(cd "$repo_path" && pwd)
failures=0

ok() { echo "[ok]      $1"; }
fail() {
  echo "[missing] $1"
  failures=$((failures + 1))
}

check_file() {
  local rel="$1"
  if [ -f "$repo_path/$rel" ]; then
    ok "$rel"
  else
    fail "$rel"
  fi
}

check_contains() {
  local rel="$1"
  local pattern="$2"
  local label="$3"
  local f="$repo_path/$rel"
  if [ ! -f "$f" ]; then
    fail "$label (file missing: $rel)"
    return
  fi
  if grep -Eq "$pattern" "$f"; then
    ok "$label"
  else
    fail "$label"
  fi
}

echo "Auditing control metalayer: $repo_path"
echo

baseline=(
  "AGENTS.md"
  "PLANS.md"
  "METALAYER.md"
  "Makefile.control"
  "scripts/audit_control.sh"
  "scripts/control/smoke.sh"
  "scripts/control/check.sh"
  "scripts/control/test.sh"
  "docs/control/ARCHITECTURE.md"
  "docs/control/OBSERVABILITY.md"
  ".github/workflows/control-harness.yml"
)

for rel in "${baseline[@]}"; do
  check_file "$rel"
done

echo
check_contains "AGENTS.md" "Harness Commands|Control Commands" "AGENTS.md command section"
check_contains "METALAYER.md" "Setpoints" "METALAYER setpoint section"
check_contains "Makefile.control" "^control-audit:" "Makefile.control control-audit target"
check_contains ".github/workflows/control-harness.yml" "make ci" "control harness workflow invokes make ci"

if [ "$strict" -eq 1 ]; then
  echo
  strict_files=(
    ".control/policy.yaml"
    ".control/commands.yaml"
    ".control/topology.yaml"
    ".control/state.json"
    "docs/control/CONTROL_LOOP.md"
    "evals/control-metrics.yaml"
    "scripts/control/recover.sh"
    ".github/workflows/control-nightly.yml"
  )
  for rel in "${strict_files[@]}"; do
    check_file "$rel"
  done
fi

echo
if [ "$failures" -gt 0 ]; then
  echo "Control audit failed: $failures issue(s)."
  exit 1
fi

echo "Control audit passed."
