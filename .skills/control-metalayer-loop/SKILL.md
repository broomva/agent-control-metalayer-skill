---
name: control-metalayer-loop
description: Create and maintain a control-system metalayer for autonomous code-agent development in any repository. Use when you need explicit control primitives (setpoints, sensors, controller policy, actuators, feedback loop, stability and entropy controls), repo command/rule governance, and a scalable folder topology that lets agents operate safely and keep improving over time.
---

# Control Metalayer Loop

Use this skill to initialize or upgrade a repository into a control-loop driven agentic development system.

## What To Load

- `references/control-primitives.md` for the control model and minimal control law.
- `references/rules-and-commands.md` for policy/rules and command governance.
- `references/topology-growth.md` for repository topology and scale path.
- `references/wizard-cli.md` for command usage.

## Primary Entry Point

Use the Typer wizard:

```bash
python3 scripts/control_wizard.py init <repo-path> --profile governed
```

Profiles:

- `baseline`: minimal harness and command surface.
- `governed`: baseline + policy/commands/topology + control loop + metrics.
- `autonomous`: governed + recovery and nightly entropy controls.

## Workflow

1. Baseline current repo workflows and constraints.
2. Initialize baseline metalayer artifacts.
3. Add control primitives and governance rules.
4. Audit and close gaps.
5. Iterate based on run outcomes and metric drift.

## Step 1: Baseline

- Identify canonical test/lint/typecheck/build commands.
- Identify high-risk actions requiring policy gates.
- Identify required observability IDs for agent runs.

## Step 2: Initialize Metalayer

Run:

```bash
python3 scripts/control_wizard.py init <repo-path> --profile baseline
```

This creates stable operational interfaces:

- `AGENTS.md`, `PLANS.md`, `METALAYER.md`
- `Makefile.control` and `scripts/control/*`
- `docs/control/ARCHITECTURE.md` and `docs/control/OBSERVABILITY.md`
- CI workflow for control checks

## Step 3: Add Control Primitives

Run:

```bash
python3 scripts/control_wizard.py init <repo-path> --profile governed
```

This adds the core control plane:

- `.control/policy.yaml`
- `.control/commands.yaml`
- `.control/topology.yaml`
- `docs/control/CONTROL_LOOP.md`
- `evals/control-metrics.yaml`

For a fully self-sustaining loop:

```bash
python3 scripts/control_wizard.py init <repo-path> --profile autonomous
```

Adds:

- `scripts/control/recover.sh`
- `.control/state.json`
- `.github/workflows/control-nightly.yml`

## Step 4: Validate

Run:

```bash
python3 scripts/control_wizard.py audit <repo-path>
python3 scripts/control_wizard.py audit <repo-path> --strict
```

Treat audit failures as blocking until corrected.

## Step 5: Operate And Grow

- Keep command names stable (`smoke`, `check`, `test`, `recover`).
- Keep policy and command catalog synchronized with actual behavior.
- Track control metrics and adjust setpoints deliberately.
- Prune stale rules/scripts/docs to prevent entropy growth.

## Adaptation Rules

- Do not overwrite existing project conventions without explicit reason.
- Prefer wrappers and policy files over ad-hoc command execution.
- Make every major behavior observable and auditable.
- Keep human escalation rules explicit and easy to trigger.
