# CI

GitHub Actions runs three independent checks for pull requests and repeats them after changes merge to `main`:

- Frontend JVM, Android, JS, and Wasm tests when `frontend/` changes
- Backend tests when `backend/` changes
- Both test suites when the shared `api/` contract changes
- Markdown lint on every change

The frontend and backend workflows also run when their own workflow file or the root `Makefile` changes.

Feature-branch pushes are handled by the pull request event, so they do not also create duplicate push runs.

CI calls the same `make test-frontend`, `make test-backend`, and `make lint-markdown` targets used locally.
