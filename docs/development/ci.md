# CI

GitHub Actions runs independent checks for pull requests and repeats relevant project checks after changes merge to `main`:

- Frontend JVM, Android, JS, and Wasm tests when `frontend/` changes
- Rust formatting, Clippy with warnings denied, and backend tests when `backend/` changes
- Both test suites when the shared `api/` contract changes
- Markdown lint on every change
- Branch naming convention on pull requests

The frontend and backend checks report on every pull request so they can be required without remaining pending. Their language setup and test steps are skipped unless the relevant project, shared API contract, root `Makefile`, or workflow changes.

Feature-branch pushes are handled by the pull request event, so they do not also create duplicate push runs.

CI calls the same `make` targets used locally: `test-frontend`, `check-rust-format`, `lint-rust`, `test-backend`, and `lint-markdown`.
