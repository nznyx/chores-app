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

## Domain separation

Core subdomains contain the specialised rules that give the product its value. Supporting subdomains require product-specific rules but do not distinguish the product. Generic subdomains solve common problems for which established solutions or standards already exist.

### Core subdomain

#### Chore and task coordination

The product's distinguishing capability is coordinating recurring and one-off work for individuals and households.

A **chore** describes required work and the rules that produce tasks. A **task** represents a concrete piece of that work, with a due time, current state, and zero or more assignees.

This subdomain governs:

- defining and organising chores, including schedules, steps, tags, and preset-based creation;
- turning each scheduled occurrence into actionable tasks without duplicates;
- selecting eligible people and applying individual, group, all-member, and household single-action assignment modes;
- claiming, releasing, redistributing, pausing, and completing tasks;
- enforcing permissions and granted access to household and personal work;
- deciding when and whom to remind, including suppression during busy calendar periods;
- recording completion history;
- resolving conflicting task actions, including actions submitted after working offline;
- responding to membership and availability changes by pausing or redistributing work.

### Supporting subdomains

#### Household membership and access

This subdomain manages households, invitations, memberships, administrative roles, active household selection, vacation periods, and read-only sharing of personal chores. It supplies membership, availability, and access grants to chore and task coordination, which decides how they affect work.

#### Scoring

Scoring calculates household leaderboards, personal scoreboards, contribution scores, and results for selected time periods. It derives them from completion history owned by chore and task coordination.

### Generic subdomains

#### Identity and accounts

The identity and accounts subdomain manages registration, authentication, linked login providers, credentials, sessions, profiles, and account lifecycle. It establishes who the caller is.

The household membership and access subdomain determines the caller's membership and administrative role. Chore and task coordination applies the work-specific permissions.

#### Notification delivery

Notification delivery manages devices, push providers, delivery attempts, failures, and retries. It receives an already-decided message, delivery time, and audience from chore and task coordination.

#### Calendar interoperability

Calendar interoperability manages calendar import, export, and provider connections and exposes busy periods in a common form. Chore and task coordination decides how those periods affect reminders.
