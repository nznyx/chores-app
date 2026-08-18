# Makefile

All project actions go through `make`. Run `make help` to see every available target.

**Source of truth:** [`Makefile`](https://github.com/nznyx/chores-app/blob/main/Makefile) — `make help` prints targets directly from the file, so it never goes stale.

## Convention

When adding new automation:

1. Add the target in `Makefile`
2. CI calls `make <target>` — never inline tool commands in `ci.yml`

## Dependencies

| Tool | Purpose |
|------|---------|
| `./frontend/gradlew` | Kotlin build, lint, test |
| `cargo`, `rustfmt`, `clippy` | Rust formatting, linting, build, and test |
| `node` / `npx` | markdownlint-cli2 |
| `uv` | Pinned MkDocs Material tooling |

Run `make setup` to install Node dependencies and prepare the documentation tools.

## Documentation

- `make docs-serve` serves the current checkout locally.
- `make docs-build` builds the current checkout into `site/`.
