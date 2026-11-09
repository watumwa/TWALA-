# TWALA Decision Register

Status values: **Accepted**, **Proposed**, **Open**, **Deferred**.

## Accepted direction

| ID | Status | Decision | Reason |
|---|---|---|---|
| DEC-001 | Accepted | Use a fresh current-stable Flutter foundation for both mobile apps. | Avoid legacy tooling and share mobile design/domain code. |
| DEC-002 | Accepted | Keep Customer and Captain as separate installable applications. | Distinct users, permissions, release risk, and location behavior. |
| DEC-003 | Accepted | Deliver an interactive frontend before production backend implementation. | Validate workflows and scope early. |
| DEC-004 | Accepted | Treat the legacy SafeBoda repository as reference only. | It is not production-ready and does not implement TWALA's business rules. |
| DEC-005 | Accepted | Preserve Captain in the provider app and internal account model; use Rider/Driver in customer context. | Required business terminology. |

## Proposed technical decisions

| ID | Status | Decision | Validation required |
|---|---|---|---|
| DEC-010 | Proposed | Next.js/TypeScript for Operations Dashboard. | Confirm team ownership and hosting approach. |
| DEC-011 | Proposed | Django REST Framework modular monolith for backend. | Confirm team capability and performance test plan. |
| DEC-012 | Proposed | PostgreSQL/PostGIS for transactional and geospatial data. | Validate hosting, backup, and Hoima query performance. |
| DEC-013 | Proposed | Redis, workers, and WebSockets for matching, expiry, notifications, and live state. | Define failure and recovery model. |
| DEC-014 | Proposed | Google Maps or Mapbox selected after a Hoima coverage/cost spike. | Test roads, landmarks, autocomplete, routing, and recurring costs. |
| DEC-015 | Proposed | Double-entry, append-only financial ledger. | Review with finance and payment-provider specialists. |
| DEC-016 | Proposed | Managed object storage for verification files with private signed access. | Confirm region, retention, and privacy obligations. |

## Critical business and compliance decisions

These block reliable production implementation but do not block a clearly labelled mock prototype.

| ID | Status | Question / required output | Owner |
|---|---|---|---|
| DEC-100 | Open | What exact fare formula, rounding rule, currency precision, and tax treatment apply? | TWALA Finance |
| DEC-101 | Open | What are the approved boda-boda and car base, minimum, distance, time, waiting, zone, cancellation, and peak values? | TWALA Operations/Finance |
| DEC-102 | Open | When does waiting start, pause, resume, and stop? | TWALA Operations |
| DEC-103 | Open | What is the cancellation matrix by actor, trip stage, reason, and fee? | TWALA Operations |
| DEC-104 | Open | Which licensed payment provider will handle collections, payouts, refunds, and settlement? | TWALA Legal/Finance |
| DEC-105 | Open | Is “TWALA Wallet” stored value, a ledger representation of PSP-held funds, or another approved structure? | TWALA Legal/Finance |
| DEC-106 | Open | What deposit, withdrawal, velocity, and transaction limits apply? | TWALA Finance/Compliance |
| DEC-107 | Open | Which actions require maker-checker approval and at what thresholds? | TWALA Finance |
| DEC-108 | Open | What formula controls cash-booking eligibility and commission cover? | TWALA Finance/Operations |
| DEC-109 | Open | Which provider documents are mandatory for boda-boda and car, and when do they expire? | TWALA Verification/Legal |
| DEC-110 | Open | What passenger-presence proof starts a trip: PIN, OTP, QR, or another control? | TWALA Operations/Safety |
| DEC-111 | Open | What emergency/SOS workflow, response team, and escalation times are required? | TWALA Safety/Legal |
| DEC-112 | Open | What precise data retention periods apply to GPS, identity documents, trips, messages, and finance? | TWALA Legal |
| DEC-113 | Open | Where may data be hosted and what cross-border processing approvals are required? | TWALA Legal/Privacy |
| DEC-114 | Open | Which SMS/OTP provider and sender identity will be used? | TWALA Technical/Operations |
| DEC-115 | Open | What are expected pilot and year-one passengers, Captains, concurrent trips, and GPS update volume? | TWALA Business |
| DEC-116 | Open | What pilot boundaries apply: dates, hours, zones, provider count, passenger count, and transaction limits? | TWALA Operations |
| DEC-117 | Open | Are English and Luganda/Bunyoro-localised interfaces required at launch? | TWALA Product |
| DEC-118 | Open | What support hours and complaint/safety severity SLAs apply? | TWALA Support/Safety |
| DEC-119 | Open | What account deletion, suspension appeal, and data-subject request processes apply? | TWALA Legal/Support |
| DEC-120 | Open | Who owns each production account: source control, cloud, app stores, maps, SMS, email, monitoring, and payments? | TWALA Management |

## Prototype assumptions requiring confirmation

- Hoima City is the initial visible operating area.
- Currency is UGX and prototype values are explicitly fictional.
- The prototype uses simulated OTP, provider locations, ride progress, and payment outcomes.
- No prototype action moves real money, sends production SMS, or represents a legally verified Captain.
- Customer and Captain demos use separate sample accounts and datasets.
- Maps may use static/mock routes until commercial API keys and billing are approved.

## Required stakeholder sessions

1. Product and operations workflow workshop.
2. Fare and commission workshop.
3. Wallet, payment, reconciliation, and legal workshop.
4. Captain verification and safety workshop.
5. Roles, permissions, reporting, and audit workshop.
6. Prototype playback and scope-signoff meeting.

