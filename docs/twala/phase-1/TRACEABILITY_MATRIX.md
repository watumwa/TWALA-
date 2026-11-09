# TWALA Requirements Traceability Matrix

This Phase 1 matrix maps requirements to prototype evidence. Production acceptance must add automated test IDs, API evidence, security evidence, and client UAT results.

| Requirement group | Prototype screens or artefact | Demonstration evidence | Production evidence later |
|---|---|---|---|
| BR-001–BR-010 | Customer booking; Captain request/trip; dashboard trip detail | Cash boda booking, cashless car booking, ID/QR pairing, competing acceptance | Matching/state-machine tests and concurrency evidence |
| BR-011–BR-016 | Completion summary; wallet; commission; finance dashboard | Cash commission restriction; cashless allocation; withdrawal failure | Ledger invariants, reconciliation, idempotency, finance UAT |
| CUS-001–CUS-004 | Customer screens 1–5, 26–29 | Registration, invalid/expired OTP, profile/history | Auth, rate-limit, session, privacy, and recovery tests |
| CUS-010–CUS-018 | Customer screens 6–13, 20–21 | Standard booking, no provider, ID pairing, QR unavailable | Map, fare, matching, eligibility, and timeout tests |
| CUS-020–CUS-025 | Customer screens 14–19 | Arrival, start verification, trip, destination change, receipt | GPS, state transition, recovery, cancellation, and fare tests |
| CUS-030–CUS-036 | Customer screens 22–29 | Deposit failure, withdrawal restoration, complaint escalation | PSP sandbox, ledger, reservation, support, and audit tests |
| CAP-001–CAP-004 | Captain screens 1–5 | Application, request-more-information, approval | Upload security, verification permissions, and history tests |
| CAP-010–CAP-014 | Captain screens 6–8 | Online/eligibility, accept/reject/expiry | Location permission, eligibility, locking, and expiry tests |
| CAP-020–CAP-025 | Captain screens 9–13 | Navigate, arrive, start, complete, cancel | Trip lifecycle, offline recovery, and timestamp tests |
| CAP-030–CAP-035 | Captain screens 14–20 | Earnings, restriction, wallet, notifications | Ledger projection, permissions, and notification tests |
| OPS-001–OPS-005 | Dashboard screens 1–7 | KPI/map, Passenger, Captain verification, trip timeline | RBAC, privacy, query, and real-time integration tests |
| OPS-006–OPS-013 | Dashboard screens 8–18 | Fare version, finance, complaints, roles, audit | Maker-checker, reconciliation, exports, and immutable audit tests |
| SYS-001–SYS-005 | Booking/trip scenarios and solution state models | Status synchronises across all three demos | API contract, locking, WebSocket, recovery, and load tests |
| SYS-010–SYS-013 | Fare estimate, destination change, fare dashboard | Estimate and revised fare explanation | Versioned fare-engine unit/property tests |
| SYS-020–SYS-024 | Wallet/ledger/withdrawal demo | No credit on failure; reserve/release; correction trail | Double-entry invariants, callback replay, and reconciliation |
| SYS-030–SYS-032 | Notifications in both apps and dashboard templates | Rider/Driver/Captain wording by context | Template version, delivery retry, and channel tests |
| NFR-001–NFR-012 | UX states, role matrix, solution blueprint | Permission denial, offline/stale state, audit views | Security, performance, backup restore, accessibility, and monitoring reports |

## Traceability rules

- A prototype screen cannot close a production requirement by itself.
- Every accepted production requirement must have at least one verification method and accountable owner.
- Changes to requirements must update the SRS, affected journeys, prototype scope, estimate, and acceptance evidence.
- Financial and safety requirements require negative/failure-path evidence, not only a successful demonstration.

