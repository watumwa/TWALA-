# TWALA Software Requirements Specification — Draft

Version: 0.1  
Status: Working draft; not yet approved for production implementation

## 1. Product objective

TWALA is a mobility platform launching initially in Hoima City, Uganda. It connects passengers with independently registered and verified boda-boda Riders and car Drivers. It consists of:

1. TWALA Customer App.
2. TWALA Captain App.
3. TWALA Operations Dashboard.
4. One shared backend and central operational and financial data platform.

The platform must support future operating areas and service categories through configuration wherever practical.

## 2. Actors and terminology

| Actor | Meaning | Required customer-facing term |
|---|---|---|
| Passenger | Person requesting or taking a trip | Passenger where appropriate |
| Boda-boda provider | Verified provider serving a boda-boda booking | Rider |
| Car provider | Verified provider serving a car booking | Driver |
| Provider account | Internal/provider-facing identity | Captain |
| Operations staff | Authorised TWALA employee | Role-specific title |

The product name **TWALA Captain App** and the term **Captain** in the provider-facing application must remain unchanged.

## 3. Core business rules

- BR-001: Initial service categories are boda-boda and car.
- BR-002: A Captain must be approved, online, available, and eligible before receiving a request.
- BR-003: A Passenger must see an estimated fare before confirming a booking.
- BR-004: A Passenger must select Cash, Cashless, or an eligible TWALA Wallet option before provider matching begins.
- BR-005: The system must never silently change the selected payment method.
- BR-006: Cash eligibility and cashless eligibility are evaluated independently.
- BR-007: Provider eligibility must be rechecked immediately before assignment.
- BR-008: Standard, provider-ID, and QR bookings use the same trip, fare, payment, tracking, and commission controls.
- BR-009: Entering a provider ID or scanning a QR code must not automatically start a trip; the Captain must accept.
- BR-010: One Captain cannot be assigned to multiple active trips.
- BR-011: The standard completed-trip allocation is 10% to TWALA and 90% to the provider, before separately approved charges.
- BR-012: Money is credited only after authoritative payment confirmation, never merely after initiation.
- BR-013: Funds for a pending withdrawal are reserved against double spending.
- BR-014: Manual financial adjustments require reason, authorisation, and immutable audit history.
- BR-015: Completed trips retain the fare rules and values that applied to them, even after later tariff changes.
- BR-016: Provider financial eligibility and TWALA company settlement liquidity are distinct controls.

## 4. Customer App requirements

### 4.1 Account and identity

- CUS-001: Register using mobile number and OTP verification.
- CUS-002: Create and edit a basic profile.
- CUS-003: Support secure session recovery and logout.
- CUS-004: Display account activity, trips, wallet transactions, complaints, and notifications.

### 4.2 Booking

- CUS-010: Select boda-boda or car without mixing service-specific terminology.
- CUS-011: Detect pickup using GPS and allow manual map adjustment.
- CUS-012: Search for and confirm a destination.
- CUS-013: Show a route and fare estimate where mapping data permits.
- CUS-014: Present service, pickup, destination, estimate, and payment method on confirmation.
- CUS-015: Submit a standard nearby-provider request.
- CUS-016: Pair with a verified provider using a unique provider ID.
- CUS-017: Pair by scanning a secure provider QR reference.
- CUS-018: Explain when no provider is eligible and permit retry or an explicit payment-method change.

### 4.3 Active trip

- CUS-020: Display the accepted provider's verified information and vehicle details.
- CUS-021: Show provider approach and active-trip location updates subject to privacy rules.
- CUS-022: Display booking and trip status transitions.
- CUS-023: Support authorised cancellation and required reason capture.
- CUS-024: Require confirmation for a destination change that materially changes the fare.
- CUS-025: Present a completed-trip receipt and rating flow.

### 4.4 Wallet, support, and history

- CUS-030: Display available wallet balance and transaction history.
- CUS-031: Initiate deposits through supported payment channels.
- CUS-032: Request eligible withdrawals to registered destinations.
- CUS-033: Pay an eligible trip from sufficient available wallet funds.
- CUS-034: Display pending, successful, failed, reversed, and refunded states accurately.
- CUS-035: Display trip history and trip details.
- CUS-036: Submit general complaints and identifiable safety reports linked to a trip where applicable.

## 5. Captain App requirements

### 5.1 Registration and verification

- CAP-001: Register using mobile number and OTP.
- CAP-002: Submit identity, photograph, service category, vehicle, and required document information.
- CAP-003: Display pending, additional-information, approved, rejected, suspended, and deactivated states.
- CAP-004: Prevent unapproved Captains from receiving normal requests.

### 5.2 Availability and requests

- CAP-010: Switch online or offline when the account is eligible.
- CAP-011: Send location at an approved, battery-conscious interval while online or on trip.
- CAP-012: Display incoming request information, payment method, estimate, and response deadline.
- CAP-013: Accept or reject a request.
- CAP-014: Prevent conflicting active assignments.

### 5.3 Trip lifecycle

- CAP-020: Navigate to pickup.
- CAP-021: Mark arrival.
- CAP-022: Start a trip using an approved passenger-presence verification rule.
- CAP-023: Navigate during a trip and handle temporary connectivity loss.
- CAP-024: Complete a trip and display the final fare/allocation.
- CAP-025: Cancel with an approved reason when permitted.

### 5.4 Finance and support

- CAP-030: Distinguish gross earnings, provider share, available balance, pending settlement, and outstanding commission.
- CAP-031: Display cash and cashless trip records.
- CAP-032: Display cash and cashless eligibility separately, including restriction reasons.
- CAP-033: Support eligible deposits and withdrawals.
- CAP-034: Display immutable transaction and commission history.
- CAP-035: Receive verification, request, trip, earnings, restriction, and support notifications using Captain terminology.

## 6. Operations Dashboard requirements

- OPS-001: Show operational KPIs without exposing data beyond the user's role.
- OPS-002: Display a privacy-controlled live map of relevant Captains and active trips.
- OPS-003: Search and manage Passenger accounts and activity.
- OPS-004: Review Captain applications, documents, approval history, status, and eligibility.
- OPS-005: Search trips by reference, user, service, date, status, payment method, and booking method.
- OPS-006: Configure versioned fares by service category and operating area.
- OPS-007: Monitor wallets, deposits, withdrawals, payments, refunds, reversals, commissions, and settlements.
- OPS-008: Reconcile platform records with payment-provider records.
- OPS-009: Manage complaints with assignment, escalation, status, resolution, and timestamps.
- OPS-010: Manage centrally editable notification templates with controlled dynamic fields.
- OPS-011: Export authorised operational and financial reports.
- OPS-012: Enforce role-based permissions and separation of sensitive duties.
- OPS-013: Record important user and system actions in immutable audit history.

## 7. Shared platform requirements

### 7.1 Booking and matching

- SYS-001: Use one authoritative booking and trip state machine.
- SYS-002: Filter candidates by operating area, service, verification, status, availability, proximity, trip status, and payment eligibility.
- SYS-003: Prevent concurrent assignment through transactional locking or an equivalent atomic control.
- SYS-004: Record why candidates were excluded and why an assignment was made, at an appropriate audit level.
- SYS-005: Synchronise status across both apps and the dashboard.

### 7.2 Fares

- SYS-010: Calculate fares only in the backend using versioned configuration.
- SYS-011: Support base, minimum, distance, time, waiting, zone, cancellation, peak, and authorised adjustment components.
- SYS-012: Prevent overlapping time components from double-charging the same period.
- SYS-013: Record estimate inputs, final inputs, rule version, and authorised adjustments.

### 7.3 Financial ledger

- SYS-020: Maintain a double-entry ledger with unique, idempotent transaction references.
- SYS-021: Derive balances from posted ledger entries rather than editable totals.
- SYS-022: Separate available, reserved, pending, payable, and outstanding-commission positions.
- SYS-023: Make payment callbacks idempotent and retain raw provider references safely.
- SYS-024: Support reconciliation, corrections through reversing entries, and full auditability.

### 7.4 Notifications

- SYS-030: Support in-app, push, SMS, and email where approved.
- SYS-031: Select Rider, Driver, Passenger, or Captain wording from recipient and service context.
- SYS-032: Record notification request, channel, delivery status, retry history, and template version.

## 8. Roles and sensitive permissions

Initial dashboard roles:

- Super Administrator
- Operations Manager
- Finance Officer
- Verification Officer
- Customer Support Officer
- Reporting/Read-only User

The permission matrix must be defined at action level. Financial adjustment, withdrawal approval, fare publication, and audit access require specific permissions. Production should support maker-checker approval for high-risk actions such as large withdrawals and manual financial adjustments; thresholds remain an open business decision.

## 9. Non-functional requirements

- NFR-001 Security: Encrypt traffic, protect secrets, use secure authentication, and apply least privilege.
- NFR-002 Privacy: Minimise retained location and identity data and restrict access by purpose.
- NFR-003 Reliability: Make booking and financial operations idempotent and recoverable after retries.
- NFR-004 Weak networks: Preserve local state, show synchronisation status, and safely retry without duplicate actions.
- NFR-005 Performance: Define measurable API, matching, and location-update targets during technical design.
- NFR-006 Battery: Use context-aware location frequency rather than permanent maximum-frequency tracking.
- NFR-007 Scalability: Partition configuration by operating area and service category.
- NFR-008 Auditability: Retain actor, timestamp, reason, previous value, and new value for controlled changes.
- NFR-009 Backup: Define encrypted backup frequency, retention, restore ownership, RPO, and RTO.
- NFR-010 Accessibility: Support readable contrast, scalable text, clear status communication, and touch targets suitable for moving/field users.
- NFR-011 Observability: Centralise error reporting, metrics, security events, and integration health.
- NFR-012 Ownership: Keep source, cloud, domain, app-store, mapping, messaging, and payment accounts under agreed TWALA control.

## 10. First-release boundary

The client's requested first operational release includes the core Customer App, Captain App, dashboard, GPS, payments, deposits, withdrawals, wallets, commission, reports, complaints, permissions, and audit history. This is not a small MVP.

Recommended delivery control:

1. Prototype release: interactive mocked frontend only.
2. Technical alpha: real authentication and one end-to-end cash booking flow.
3. Integrated beta: cashless, ledger, wallets, ID/QR pairing, and operations controls.
4. Hoima pilot: production-like providers and passengers under controlled limits.
5. Public release: only after pilot acceptance and reconciliation evidence.

Explicitly deferred unless later approved: referrals, promotions, loyalty, scheduled rides, corporate accounts, advanced analytics, and general multi-city launch.

## 11. Acceptance baseline

A feature is not accepted only because a screen exists. Acceptance requires:

- The authorised actor can complete the end-to-end workflow.
- Invalid, unauthorised, duplicate, offline, timeout, and integration-failure cases behave safely.
- State synchronises across relevant surfaces.
- Financial and privileged changes are traceable.
- Automated tests cover critical business rules.
- Client UAT evidence maps to requirement IDs.

## 12. Approval status

This draft is suitable for a requirements workshop and prototype planning. It is not ready for production implementation until the critical open decisions in `DECISION_REGISTER.md` have owners and approved answers.

