# CI

GitHub Actions runs independent checks for pull requests and repeats relevant project checks after changes merge to `main`:

- Separate Kotlin/JVM, Android, JavaScript, and WebAssembly test jobs when `frontend/` changes
- Separate Rustfmt, Clippy with warnings denied, and Rust test jobs when `backend/` changes
- Both test suites when the shared `api/` contract changes
- Markdown lint on every change
- Branch naming convention on pull requests

The frontend and backend workflows start for every pull request. A change-detection job skips unrelated project jobs, and each workflow reports a final all-clear gate that succeeds only when every relevant job passes. Pushes to `main` retain workflow-level path filters because they are not pull-request merge gates.

Feature-branch pushes are handled by the pull request event, so they do not also create duplicate push runs.

CI calls the same `make` targets used locally, including separate targets for each frontend platform and Rust quality check.
