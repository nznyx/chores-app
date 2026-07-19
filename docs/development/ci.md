# CI/CD

Runs on push/PR to `main` and `develop`.

**Source of truth:** [`.github/workflows/ci.yml`](https://github.com/nznyx/chores-app/blob/main/.github/workflows/ci.yml).

Flow: `lint` → `test` → builds + docs in parallel → gate.

## Convention

1. Every CI step calls a `make` target — never raw tool invocations
2. Add the job to `ci.yml`
3. If gating, add to `ci-success` needs
