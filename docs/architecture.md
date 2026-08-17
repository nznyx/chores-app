# Architecture

## System overview

The Kotlin Multiplatform frontend communicates with the Rust backend through a versioned HTTP API.

```text
KMP frontend → HTTP/JSON API → Rust backend → database
```

## Repository structure

- `frontend/` contains the complete Gradle and Kotlin Multiplatform project.
- `backend/` contains the Rust application.
- `api/openapi.yaml` is the contract shared by both projects.
- `docs/` contains requirements, architecture, and development documentation.

The frontend and backend build independently. Changes that affect their API boundary must update the OpenAPI contract in the same pull request.
