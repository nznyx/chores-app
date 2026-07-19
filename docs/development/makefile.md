# Makefile

All project actions go through `make`. Run `make help` to see everything.

## Targets

| Target | Description |
|--------|-------------|
| `help` | Show all available targets |
| `setup` | Install tooling deps (npm + Python) |
| `lint` | ktlint + detekt + markdownlint |
| `lint-kotlin` | ktlint + detekt only |
| `lint-markdown` | markdownlint-cli2 only |
| `format` | Auto-format Kotlin (ktlintFormat) |
| `check-format` | Check formatting, fail if unformatted |
| `test` | All JVM tests |
| `build` | Desktop + android |
| `build-desktop` | Desktop Debian package |
| `build-android` | Android debug APK |
| `build-ios` | iOS frameworks (macOS only) |
| `clean` | Remove build artifacts + node_modules/ |
| `docs-setup` | Install mkdocs + material theme |
| `docs-serve` | Serve docs at localhost:8000 |
| `docs-build` | Build static site |
| `docs-deploy` | Deploy to GitHub Pages |
| `ci` | Same checks as CI (lint + test + desktop) |

## Adding a new CI action

CI checks **must** use `make` targets — never inline Gradle commands in `ci.yml`.

1. Add the target in `Makefile`
2. Call `make <target>` in `.github/workflows/ci.yml`
3. If gating, add to `ci-success`'s `needs` list

## Dependencies

| Tool | Purpose |
|------|---------|
| `./gradlew` | Kotlin build |
| `node` / `npx` | markdownlint-cli2 |
| `python3` / `uv` or `pip` | mkdocs |

Run `make setup` to install Node and Python deps.
