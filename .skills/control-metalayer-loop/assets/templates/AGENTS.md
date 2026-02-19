# AGENTS.md

## Project Goal

- Product objective:
- Quality objective:
- Reliability objective:

## Control Commands

| Intent | Command |
|---|---|
| Quick environment and build sanity | `make smoke` |
| Static quality gates | `make check` |
| Full verification | `make test` |
| Recovery playbook | `make recover` |
| Metalayer audit | `make control-audit` |

## Rules

- Never bypass `check` or `test` without explicit escalation.
- Keep changes scoped to one plan objective at a time.
- Update control docs and policy when behavior changes.
- Escalate to human when retry budget is exhausted.

## Execution Plans

- For tasks > 30 minutes, update `PLANS.md` before coding.
- Record checkpoints and final verification commands.

## Observability

- Include `run_id`, `trace_id`, and `task_id` in major workflow logs.
