# CI/CD

Runs on push/PR to `main` and `develop`.

## Jobs

| Job | Command | Runner |
|-----|---------|--------|
| Lint | `make lint` | ubuntu-latest |
| Tests | `make test` | ubuntu-latest |
| Build Desktop | `make build-desktop` | ubuntu-latest |
| Build Android | `make build-android` | ubuntu-latest |
| Build iOS | `make build-ios` | macos-latest |
| Docs | `make docs-build` | ubuntu-latest |

Flow: `lint` → `test` → builds + docs in parallel → gate.

## Adding a check

1. Add a `make` target
2. Add a job in `ci.yml` calling that target
3. Add to `ci-success` needs if gating

Never write raw Gradle or tool invocations in `ci.yml` — use `make`.
