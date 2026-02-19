# Wizard CLI

Main tool: `scripts/control_wizard.py`

## Init

```bash
python3 scripts/control_wizard.py init <repo-path> --profile baseline
python3 scripts/control_wizard.py init <repo-path> --profile governed
python3 scripts/control_wizard.py init <repo-path> --profile autonomous
```

## Audit

```bash
python3 scripts/control_wizard.py audit <repo-path>
python3 scripts/control_wizard.py audit <repo-path> --strict
```

## Status

```bash
python3 scripts/control_wizard.py status <repo-path>
```

## Primitive Operations

```bash
python3 scripts/control_wizard.py primitive list
python3 scripts/control_wizard.py primitive add policy loop --repo <repo-path>
```
