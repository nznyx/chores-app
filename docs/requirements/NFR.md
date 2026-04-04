# Non-Functional Requirements

---

## Performance

### NFR-01: API Response Time
**Description:** All standard API endpoints shall respond within an acceptable time under normal load
**Rationale:** Slow responses degrade the experience, especially for chore completion and real-time scoreboard updates
**Criteria:** 95th percentile response time ≤ 300ms under normal load; ≤ 1s under peak load
**Priority:** High

### NFR-02: App Cold Start Time
**Description:** The application shall reach an interactive state quickly after launch
**Rationale:** Users typically open the app briefly to check or complete tasks; a slow start creates friction
**Criteria:** Cold start to interactive state ≤ 2 seconds on mid-range Android and iOS devices
**Priority:** Medium

### NFR-03: Widget Refresh Latency
**Description:** The home screen widget shall reflect up-to-date task data within a reasonable time window
**Rationale:** Stale widget data causes users to miss new tasks or attempt to complete already-finished ones
**Criteria:** Widget data refreshed within 15 minutes of any underlying data change; refreshed immediately upon foreground app sync
**Priority:** Medium

### NFR-04: Real-Time Scoreboard Update
**Description:** Scoreboard updates triggered by chore completions shall be reflected to all active household members with minimal delay
**Rationale:** Real-time feedback reinforces the collaborative and gamified nature of the scoreboard
**Criteria:** Scoreboard update visible to all active members within 3 seconds of the completion event under normal network conditions
**Priority:** Medium

### NFR-05: Push Notification Delivery
**Description:** Push notifications for due chores and task claim events shall be delivered promptly
**Rationale:** Late notifications for due chores or task releases undermine the notification claiming flow
**Criteria:** Notifications delivered within 10 seconds of the triggering event under normal conditions; delivery subject to platform APNs/FCM constraints outside the system's control
**Priority:** High

---

## Scalability

### NFR-06: Concurrent User Support (Hosted Service)
**Description:** The hosted backend shall support a meaningful number of concurrent active users without performance degradation
**Rationale:** The app serves families and couples across multiple households; the hosted service must scale to a viable user base
**Criteria:** System maintains NFR-01 response time targets with up to 10,000 concurrent active users; architecture horizontally scalable beyond this threshold
**Priority:** Medium

### NFR-07: Self-Hosted Instance Footprint
**Description:** A self-hosted backend instance shall be operable on modest hardware typical of a home server or small VPS
**Rationale:** Self-hosters commonly run on low-power hardware such as a Raspberry Pi or a budget VPS; the backend must not require enterprise-grade resources
**Criteria:** Fully functional instance operable on a single machine with 1 vCPU and 512MB RAM for a household of up to 20 members
**Priority:** Medium

---

## Reliability & Availability

### NFR-08: Hosted Service Availability
**Description:** The hosted backend service shall maintain high availability
**Rationale:** Chore reminders and notifications are time-sensitive; prolonged downtime causes missed tasks and broken household routines
**Criteria:** Monthly uptime ≥ 99.5%; planned maintenance windows communicated at least 24 hours in advance
**Priority:** High

### NFR-09: Graceful Offline Degradation
**Description:** The client application shall remain partially usable when the device has no network connectivity
**Rationale:** Users should be able to view and complete tasks even in areas with poor or absent connectivity
**Criteria:** Previously loaded chore lists for the active household and personal scope readable offline; user clearly informed of offline state and data freshness
**Priority:** High

### NFR-10: Offline Write Consistency
**Description:** Write actions performed offline shall be queued locally and applied to the server in a consistent, conflict-aware manner upon reconnection
**Rationale:** Multiple users completing the same household single-action chore offline could produce duplicate completions; conflicts must be resolved gracefully
**Criteria:** Server resolves conflicts by timestamp; duplicate completions for single-action chores deduplicated server-side; user notified if their queued action was superseded by another member's action
**Priority:** Medium

### NFR-11: Scheduled Job Reliability
**Description:** Recurring chore instance generation, vacation mode expiry, and reminder dispatch shall execute reliably and on schedule
**Rationale:** Missed scheduled jobs result in absent chore instances, unrestored vacation tasks, and undelivered reminders
**Criteria:** Scheduled jobs execute within 60 seconds of their scheduled time; jobs missed due to downtime are recovered and executed upon service restart with no silent data loss
**Priority:** High

---

## Security

### NFR-12: Encryption in Transit
**Description:** All communication between client and server shall be encrypted
**Rationale:** User credentials, chore data, and household membership information must not be interceptable in transit
**Criteria:** All API communication over HTTPS with TLS 1.2 or higher; plain HTTP connections rejected or permanently redirected
**Priority:** High

### NFR-13: Encryption at Rest
**Description:** Sensitive user data stored in the database shall be protected at rest
**Rationale:** Protects user data in the event of a storage-level compromise
**Criteria:** Passwords stored as salted hashes using bcrypt or Argon2; personally identifiable information encrypted at the database layer
**Priority:** High

### NFR-14: Token Security
**Description:** Access tokens shall be short-lived and refresh tokens shall be securely stored and rotated on each use
**Rationale:** Limits the blast radius of a compromised token
**Criteria:** Access token TTL ≤ 15 minutes; refresh tokens stored in HttpOnly cookies or secure platform device storage; refresh tokens rotated on each use and fully invalidated on logout
**Priority:** High

### NFR-15: Server-Side Authorization
**Description:** All permission and role checks shall be enforced server-side; client-side enforcement is for UX guidance only
**Rationale:** A malicious or modified client must not be able to bypass permission rules by manipulating UI state
**Criteria:** Every API endpoint validates the requesting user's permissions against the server-side permission model before executing any action; no endpoint trusts client-reported role or permission state
**Priority:** High

### NFR-16: Rate Limiting
**Description:** The API shall apply rate limiting to prevent abuse and brute-force attacks
**Rationale:** Authentication endpoints are particularly vulnerable to credential stuffing; all endpoints need protection against bulk abuse
**Criteria:** Authentication endpoints limited to 10 attempts per minute per IP; general API endpoints limited to 300 requests per minute per authenticated user; limits configurable for self-hosted instances
**Priority:** Medium

### NFR-17: Input Validation and Sanitisation
**Description:** All user-supplied input shall be validated and sanitised server-side before processing or storage
**Rationale:** Prevents injection attacks, malformed data, and unexpected application behaviour
**Criteria:** All inputs validated against defined schemas; string fields sanitised to prevent XSS and SQL injection; validation errors returned with descriptive, non-leaking messages
**Priority:** High

---

## Platform Support

### NFR-18: Android Support
**Description:** The application shall support Android devices running a reasonably modern OS version
**Rationale:** Wide Android version coverage maximises the reachable user base
**Criteria:** Full functionality on Android API level 26 (Android 8.0) and above; home screen widget requires Android API level 26 minimum
**Priority:** High

### NFR-19: iOS Support
**Description:** The application shall support iOS devices running a reasonably modern OS version
**Rationale:** iOS is a primary target platform alongside Android
**Criteria:** Full functionality on iOS 15 and above; home screen widget requires iOS 16 (WidgetKit) minimum
**Priority:** High

### NFR-20: Responsive Layout
**Description:** The application UI shall adapt appropriately to different screen sizes and orientations
**Rationale:** The KMP/CMP stack may target multiple form factors; layouts must not break on tablets or in landscape mode
**Criteria:** All screens usable in both portrait and landscape orientations on phones; tablet layouts make use of additional screen real estate where appropriate
**Priority:** Medium

---

## Offline Support

### NFR-21: Offline Read Access
**Description:** The application shall cache sufficient data locally to allow users to view their assigned and personal chores without a network connection
**Rationale:** Users in areas with unreliable connectivity must still be able to see their tasks
**Criteria:** Most recently fetched chore data for the active household and personal scope available offline; cache age indicated to the user when viewing stale data
**Priority:** High

### NFR-22: Offline Write Queue
**Description:** Chore completions and other write actions performed offline shall be queued locally and automatically synchronised when connectivity is restored
**Rationale:** Users should not be forced to redo completed actions after coming back online
**Criteria:** Queued actions persisted across app restarts; sync attempted automatically upon connectivity restoration; user notified of pending sync items and informed of sync completion or conflicts
**Priority:** High

---

## Self-Hosting

### NFR-23: Container-Based Deployment
**Description:** The backend shall be distributed as OCI-compliant container images with an official Docker Compose configuration covering all required services
**Rationale:** Containers provide a consistent and reproducible deployment environment for self-hosters regardless of their underlying OS
**Criteria:** Official images published to a public container registry; Docker Compose file covers all required services (API server, database, job scheduler); all configuration exposed via documented environment variables
**Priority:** Medium

### NFR-24: No Mandatory External Cloud Dependencies
**Description:** A complete self-hosted deployment shall be fully operable on a single machine without requiring external managed cloud services
**Rationale:** Self-hosters must not be forced to depend on third-party cloud infrastructure beyond what they explicitly choose to configure
**Criteria:** All components (API, database, scheduler) runnable on a single host via Docker Compose; no hard dependency on external managed databases, cloud queues, or third-party storage
**Priority:** Medium

### NFR-25: Push Notifications for Self-Hosted Instances
**Description:** Self-hosted instances shall support push notification delivery via configurable platform credentials
**Rationale:** Push notifications require APNs (iOS) and FCM (Android) credentials that belong to the app or to the self-hoster; this must be configurable without code changes
**Criteria:** Backend accepts APNs and FCM credentials via environment variables; documentation provided for obtaining and configuring credentials; push notifications fully functional when valid credentials are supplied
**Priority:** Medium

### NFR-26: Data Backup and Restore
**Description:** Self-hosted instances shall support straightforward data backup and restore procedures
**Rationale:** Self-hosters are responsible for their own data durability; the system must not make backup unnecessarily complex
**Criteria:** All persistent state stored in a single standard database engine (e.g. PostgreSQL); official documentation covers backup, restore, and migration procedures; no proprietary backup tooling required
**Priority:** Medium

### NFR-27: Version Upgrade Path
**Description:** Self-hosted instances shall support upgrading to newer versions without requiring manual database intervention beyond pulling updated images
**Rationale:** Complex upgrade procedures discourage self-hosters from staying current, creating security and compatibility risks
**Criteria:** Database schema migrations applied automatically on service startup; breaking changes documented with explicit migration guides; rollback procedures documented for major version changes
**Priority:** Medium

---

## Data & Privacy

### NFR-28: Household Data Isolation
**Description:** Data belonging to one household shall never be accessible to members of another household unless explicitly shared
**Rationale:** Users must be confident that their household data is not visible to unrelated parties
**Criteria:** All data access queries scoped by household membership and validated server-side; no cross-household data leakage possible through any API endpoint
**Priority:** High

### NFR-29: Personal Chore Privacy
**Description:** Personal chores shall be visible only to their owner and any users or households explicitly granted access via the sharing feature
**Rationale:** Personal chores may include sensitive habits or health-related tasks; privacy must be enforced by default, not opt-in
**Criteria:** Personal chore data excluded from all household-scoped queries; sharing access validated server-side on every request; revoked sharing access takes effect immediately
**Priority:** High

### NFR-30: User Data Export
**Description:** Users shall be able to export all of their personal data in a portable, machine-readable format
**Rationale:** Data portability is a user right under privacy regulations such as GDPR
**Criteria:** Export includes account information, personal chores, household memberships, and chore completion history; delivered as JSON or CSV; export initiated and delivered within a reasonable time window
**Priority:** Medium

### NFR-31: Account Deletion
**Description:** Users shall be able to permanently delete their account and all associated personal data
**Rationale:** Right to erasure under GDPR and equivalent regulations
**Criteria:** Account deletion removes all personal data within 30 days of the request; household chore history attributions anonymised rather than deleted to preserve scoreboard integrity for remaining members; user shown a clear summary of what will and will not be deleted before confirming
**Priority:** Medium

---

## Accessibility

### NFR-32: Screen Reader Support
**Description:** All interactive and informational UI elements shall be accessible via platform screen readers (TalkBack on Android, VoiceOver on iOS)
**Rationale:** The app must be usable by members with visual impairments
**Criteria:** All buttons, labels, and status indicators carry meaningful accessibility labels; chore list items, step indicators, and scoreboard entries fully navigable via screen reader without information loss
**Priority:** Medium

### NFR-33: Dynamic Font Scaling
**Description:** The application UI shall respect the user's system-level font size preference
**Rationale:** Users with low vision rely on larger system font sizes; the UI must not break or clip content when this is applied
**Criteria:** All text elements scale with system font size settings; layouts remain functional and unclipped at up to 200% of the default font scale
**Priority:** Medium

### NFR-34: Colour Contrast
**Description:** Text and interactive elements shall meet minimum colour contrast ratios
**Rationale:** Sufficient contrast is necessary for users with colour vision deficiencies and in bright ambient lighting conditions
**Criteria:** All text meets WCAG 2.1 AA contrast ratio (4.5:1 for normal text, 3:1 for large text); interactive element boundaries meet 3:1 contrast against adjacent colours
**Priority:** Medium

---

## Maintainability

### NFR-35: Shared Business Logic via KMP
**Description:** Business logic, data models, scheduling rules, and API communication shall be implemented in shared Kotlin Multiplatform code, minimising platform-specific duplication
**Rationale:** A shared codebase reduces defect surface area and ensures consistent behaviour across Android and iOS
**Criteria:** Platform-specific code limited to UI rendering (Compose Multiplatform), platform notification APIs, and widget integration; all business logic resides in the shared KMP module
**Priority:** High

### NFR-36: API Versioning
**Description:** The backend API shall be versioned to allow clients and server to evolve independently
**Rationale:** Self-hosted instances may lag behind the latest server version; client apps on users' devices may not update immediately; both must continue to function correctly
**Criteria:** API versioned via URL path prefix (e.g. /v1/); previous major API version supported for a minimum of 6 months after a new major version is released; deprecation communicated via response headers
**Priority:** Medium

### NFR-37: Logging and Observability
**Description:** The backend shall emit structured logs and expose health check and basic metrics endpoints
**Rationale:** Self-hosters and operators need visibility into system health and errors without requiring proprietary monitoring tooling
**Criteria:** Structured JSON logs emitted to stdout at configurable log levels; /health endpoint returning service and dependency status; optional Prometheus-compatible metrics endpoint; no sensitive user data logged in plain text
**Priority:** Medium

---

## Localisation

### NFR-38: Internationalisation Readiness
**Description:** The application shall be built with internationalisation support, allowing UI strings to be translated without code changes
**Rationale:** The app targets a broad international audience; hardcoded strings prevent future localisation and community contribution
**Criteria:** All user-facing strings externalised into resource files; date, time, and number formatting uses locale-aware system APIs; initial release ships in English with the architecture ready to accept additional locales
**Priority:** Medium
