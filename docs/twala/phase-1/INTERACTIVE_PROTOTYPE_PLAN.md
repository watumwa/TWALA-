# TWALA Interactive Frontend Plan

## 1. Objective

Give TWALA an installable, realistic experience of the Customer App and Captain App plus a browser-based Operations Dashboard before committing to full backend implementation.

The prototype validates information architecture, terminology, interaction, business-state coverage, brand direction, and screen scope. It does not validate real payment settlement, GPS accuracy, provider matching performance, or production security.

## 2. Deliverables

- Current-stable Flutter Customer App in Demo Mode.
- Current-stable Flutter Captain App in Demo Mode.
- Next.js Operations Dashboard in Demo Mode.
- Shared TWALA visual system and component catalogue.
- Deterministic mock scenarios for stakeholder demonstrations.
- Android APKs and browser-accessible review builds where supported.
- Figma source or equivalent approved design artefact.
- Prototype acceptance checklist mapped to SRS requirement IDs.

Every surface displays a persistent Demo Mode indicator. Prototype balances, identity records, routes, OTPs, payments, and locations are fictional.

## 3. Customer App screen inventory

1. Splash and introduction
2. Mobile-number entry
3. OTP verification
4. Basic profile
5. Permissions education
6. Home/service selection
7. Pickup confirmation
8. Destination search
9. Route and fare estimate
10. Payment-method selection
11. Booking review
12. Searching/no eligible provider
13. Provider matched
14. Provider en route
15. Provider arrived/start verification
16. Active trip
17. Destination-change confirmation
18. Trip complete/receipt
19. Rating and report issue
20. Provider-ID pairing
21. QR pairing
22. Wallet overview
23. Deposit
24. Withdrawal
25. Transaction history/detail
26. Trip history/detail
27. Notifications
28. Complaints and safety report
29. Account/settings/support

## 4. Captain App screen inventory

1. Splash and mobile verification
2. Personal details
3. Service/vehicle details
4. Document capture and review
5. Application status/resubmission
6. Home with online/offline control
7. Eligibility/restriction explanation
8. Incoming request
9. Navigation to pickup
10. Arrived/start verification
11. Active trip
12. Complete/cancel trip
13. Completion and allocation summary
14. Earnings overview
15. Wallet overview
16. Deposit/withdrawal
17. Commission and transaction detail
18. Trip history
19. Notifications
20. Profile/documents/support

## 5. Operations Dashboard screen inventory

1. Sign-in and role selection for demo
2. Operational overview
3. Live-map simulation
4. Passenger list/detail
5. Captain applications/list/detail
6. Document review and decision
7. Trips list/detail/timeline
8. Fare plans and version history
9. Wallet/account overview
10. Ledger transaction detail
11. Deposits and withdrawals
12. Commission and eligibility
13. Reconciliation overview
14. Complaints queue/detail
15. Notification templates
16. Reports and exports
17. Roles and permissions
18. Audit history

## 6. Demonstration scenarios

- Successful standard boda-boda cash trip.
- Successful car cashless trip.
- No eligible provider; Passenger explicitly switches payment method.
- Successful provider-ID pairing.
- QR scan resolving an unavailable Captain.
- Captain onboarding with additional information requested, then approval.
- Cash trip creating an outstanding commission and eligibility restriction.
- Cashless payment pending then confirmed.
- Deposit failure that does not change the balance.
- Withdrawal pending with funds reserved, then failed and restored.
- Passenger complaint escalated as a safety case.
- Role-restricted dashboard action.

## 7. Visual and interaction principles

- Original TWALA identity; do not copy SafeBoda's protected visual identity.
- Clear orange/brand colour use only after client brand approval.
- Large touch targets and limited cognitive load for field use.
- High-contrast status language supported by icons, not colour alone.
- Explicit payment method and fare information before booking.
- Clear stale/offline/synchronising states.
- Rider/Driver wording in Customer App and Captain wording in Captain App.
- Financial figures use full labels and explanations; never rely on a generic “balance.”

Brand assets still required from TWALA: logo source, approved colours, type preferences, tone of voice, icon/photo rights, and any existing brand guide.

## 8. Four-week prototype schedule

### Week 1 — Product and design foundation

- Stakeholder workshop and open-decision triage.
- Information architecture and low-fidelity flows.
- Design tokens and core component direction.
- Prototype data/scenario definitions.
- Client approval of two representative screens before scaling.

### Week 2 — Customer App

- Implement the complete standard booking vertical flow.
- Add provider-ID, QR, wallet, history, complaint, and error states.
- Internal mobile usability review.

### Week 3 — Captain App and Dashboard core

- Implement onboarding, online/request/trip, eligibility, earnings, and wallet flows.
- Implement dashboard overview, maps, verification, trips, and finance views.

### Week 4 — Completion and acceptance

- Complete remaining dashboard administration and reporting views.
- Add loading, empty, timeout, offline, denied-permission, and failure states.
- Responsive and device review.
- Stakeholder playback, changes, and signed prototype acceptance.

Schedule assumes prompt access to brand assets and stakeholder decisions. Delayed approvals move the corresponding milestone.

## 9. Prototype acceptance criteria

- APKs install and launch on agreed representative Android devices.
- A reviewer can complete each demonstration scenario without developer intervention.
- Navigation contains no dead ends in approved flows.
- All monetary and identity data is visibly fictional.
- Rider, Driver, Passenger, and Captain terminology is correct by context.
- Payment choice occurs before matching in every booking path.
- Standard, ID, and QR bookings require Captain acceptance.
- Cash and cashless eligibility appear as separate states.
- Wallet screens distinguish available, reserved/pending, earnings, and outstanding commission.
- Critical loading, empty, offline, permission-denied, and failure states are represented.
- Dashboard roles demonstrate restricted actions.
- Client changes are recorded against requirement or screen IDs before approval.

## 10. Inputs needed from the client now

1. TWALA logo and brand files.
2. Two or three preferred visual references, for mood only.
3. Approved contact/support details for prototype copy.
4. Names/titles of stakeholders authorised to approve product, finance, safety, and design decisions.
5. Responses to the highest-priority items in `DECISION_REGISTER.md`.
6. At least two low-end and one mid-range Android device models to target during prototype review.

