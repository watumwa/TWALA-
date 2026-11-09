# TWALA Solution Blueprint

Status: Proposed architecture for Phase 1 review

## 1. Application structure

```text
Customer Flutter App ─┐
                     ├── HTTPS REST APIs + authenticated WebSockets
Captain Flutter App ──┤
                     │
Next.js Dashboard ────┘
                            │
                  Django modular backend
                            │
       ┌────────────────────┼─────────────────────┐
PostgreSQL/PostGIS      Redis + workers       Object storage
system of record        live/async work       private documents
```

The two mobile apps are separate release artifacts but share versioned Flutter packages for design tokens, domain models, API client behavior, validation, observability, and selected map/location abstractions.

## 2. Why not build everything from scratch

Build TWALA-specific business rules; integrate mature capabilities for commodity infrastructure.

### Build and own

- Booking, trip, and matching rules.
- Payment-method eligibility logic.
- Fare versioning and calculations.
- Commission allocation.
- Wallet ledger mappings and reconciliation rules.
- Captain verification workflow.
- TWALA terminology, user journeys, support, reporting, and audit behavior.

### Integrate

- Flutter and maintained platform plugins.
- Maps, routing, and place search.
- SMS/OTP delivery.
- Push notifications.
- Licensed collection and payout services.
- Cloud database, object storage, backups, monitoring, and crash reporting.

Third-party services reduce development time but do not transfer responsibility for secure configuration, failure handling, reconciliation, privacy, or cost control.

## 3. Proposed backend modules

- Identity and access
- Passenger profiles
- Captain profiles and verification
- Operating areas and service categories
- Location presence
- Booking and matching
- Trip lifecycle
- Fare configuration and calculation
- Payment orchestration
- Financial ledger and balances
- Commission and provider eligibility
- Notifications and templates
- Complaints and safety cases
- Reporting and exports
- Audit and compliance

These begin in one deployable modular application with enforced code/data boundaries. Splitting services should follow measured scale or operational need, not precede it.

## 4. Core entities

| Domain | Principal records |
|---|---|
| Identity | User, session, OTP challenge, role, permission |
| Passenger | Passenger profile, saved place, consent/preferences |
| Captain | Captain profile, service category, vehicle, document, verification decision |
| Geography | Operating area, service zone, place, location sample |
| Booking | Booking, booking method, candidate/offer, assignment, cancellation |
| Trip | Trip, state transition, route summary, destination change, rating |
| Fare | Fare plan, fare-rule version, estimate, final calculation, adjustment |
| Finance | Account, journal, ledger entry, payment, refund, settlement, withdrawal, reconciliation |
| Communication | Template, notification, delivery attempt |
| Support | Complaint, safety flag, assignment, evidence, resolution |
| Governance | Audit event, configuration change, approval |

No database design should store a mutable wallet balance as the sole source of truth. Cached balances may exist for performance only when they can be reproduced from the ledger.

## 5. Authoritative state models

### Booking

```text
draft -> submitted -> searching -> offered -> assigned
                    \-> no_provider
                    \-> expired
draft/submitted/searching/assigned -> cancelled (when allowed)
assigned -> trip_created
```

### Trip

```text
captain_en_route -> arrived -> start_authorised -> in_progress -> completed
       \              \             \                \-> cancelled/disputed
        \-------------- permitted cancellation paths ----------------/
```

### Payment/withdrawal

```text
created -> pending_provider -> confirmed
                         \-> failed
                         \-> expired
confirmed -> partially_refunded/refunded/reversed (controlled paths)
```

Every transition validates the current state, actor, permission, idempotency key, and business preconditions on the server.

## 6. Live location approach

- Captain device sends signed, authenticated updates while online/on trip using context-aware intervals.
- Backend validates timestamp, accuracy, plausibility, trip context, and rate limits.
- Current operational location may be cached for fast matching; required history is persisted under an approved retention policy.
- Passenger receives only the assigned provider's appropriate trip location.
- Dashboard access is role-scoped and audited.
- The apps retain pending state through short network interruptions and clearly show stale/synchronising location.

Map-provider selection requires a technical spike in Hoima for road coverage, place search, routing, quotas, licence terms, and expected cost.

## 7. Security and financial controls

- Short-lived access tokens with secure refresh/session revocation.
- OTP throttling, abuse controls, and account lock safeguards.
- Private verification documents accessed by time-limited authorisation.
- Role and object-level permissions on the backend; UI visibility is not security.
- Idempotency keys for bookings, payments, callbacks, and withdrawals.
- Signed/verified PSP callbacks and reconciliation against provider reports.
- Append-only ledger; corrections use reversal/compensating entries.
- Maker-checker controls for approved high-risk operations.
- Audit events for verification, fares, permissions, restrictions, templates, and finance.
- Encrypted backups with regularly tested restoration.
- Separate development, staging, pilot, and production environments.

## 8. Frontend architecture boundary

The prototype uses repository/service interfaces backed by deterministic mock data. Production later replaces the mock adapters with authenticated APIs without rewriting the presentation and workflow layers.

Suggested Flutter boundaries:

```text
apps/
  twala_customer/
  twala_captain/
packages/
  twala_design_system/
  twala_domain/
  twala_api_client/
  twala_mock_services/
  twala_maps/
```

The Operations Dashboard is a separate Next.js application sharing API contracts, terminology, brand tokens, and generated schemas rather than Flutter UI code.

## 9. Verification strategy

- Unit tests for fare, commission, eligibility, and state transitions.
- Contract tests for mobile/dashboard APIs.
- Integration tests for database locking, jobs, notifications, and PSP callbacks.
- Golden/widget tests for important Flutter states.
- End-to-end tests for booking, trip, payment, withdrawal, and dashboard workflows.
- Security, performance, weak-network, backup-restore, and reconciliation exercises before pilot.

