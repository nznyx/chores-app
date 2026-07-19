# .github

GitHub Actions workflows and composite actions.

## Policy: CI steps use `make` targets

All CI checks in `workflows/ci.yml` call `make <target>` — never raw Gradle or tool commands. This keeps CI and local dev in sync.

See [CI/CD docs](../docs/development/ci.md).
