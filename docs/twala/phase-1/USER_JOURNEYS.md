# TWALA User Journeys

These journeys define the behavior the interactive prototype must demonstrate and the production system must later implement.

## 1. Customer registration

1. Passenger opens the Customer App.
2. Passenger enters a mobile number and accepts applicable terms/privacy notice.
3. System sends an OTP or simulates the step in Demo Mode.
4. Passenger enters the OTP.
5. System verifies the challenge, creates or restores the account, and requests basic profile details.
6. Passenger reaches the home/service-selection screen.

Alternative states: invalid number, incorrect OTP, expired OTP, resend limit, existing suspended account, weak network.

## 2. Standard ride request

1. Passenger selects Boda-boda or Car.
2. App uses GPS for a suggested pickup; Passenger may move the pin.
3. Passenger searches for and confirms a destination.
4. Backend/prototype displays route and estimated fare.
5. Passenger selects Cash, Cashless, or eligible TWALA Wallet.
6. Confirmation shows service, pickup, destination, estimate, and payment method.
7. Passenger submits.
8. Matching considers only verified, online, available, nearby, service-compatible, payment-eligible Captains.
9. Eligible Captains receive a time-limited request.
10. One Captain accepts and assignment becomes authoritative.
11. Passenger sees Rider or Driver wording based on service.

Alternative states: GPS denied, no route, estimate unavailable, insufficient wallet balance, no eligible provider, request timeout, Passenger cancellation, competing Captain acceptance.

## 3. Provider-ID and QR pairing

1. Passenger selects provider-ID entry or QR scan.
2. System resolves only a secure provider reference.
3. Passenger sees the verified provider profile and availability result.
4. Passenger selects destination and payment method and reviews the estimate.
5. Passenger submits a pairing request.
6. Named Captain accepts or rejects.
7. Accepted pairing enters the standard trip lifecycle.

The journey must stop safely for unknown, unverified, suspended, offline, busy, wrong-service, or payment-ineligible providers. Entry/scan alone never starts a trip.

## 4. Captain registration and approval

1. Captain verifies a mobile number.
2. Captain selects provider category and supplies personal and vehicle details.
3. Captain captures/uploads required documents.
4. Captain reviews and submits the application.
5. Verification Officer reviews each requirement.
6. Officer approves, rejects, or requests more information, with a reason.
7. Captain receives the result and next action.
8. Only approved and otherwise eligible Captains may go online.

Alternative states: incomplete document, unreadable upload, expired document, duplicate identity/vehicle, resubmission, suspension, reactivation.

## 5. Captain accepts and completes a trip

1. Approved Captain goes online.
2. App begins the approved location-update mode.
3. Captain receives a request showing pickup, destination context, estimate, service, payment method, and timer.
4. Captain accepts.
5. App navigates to pickup and Captain marks arrival.
6. Passenger and Captain complete approved presence/start verification.
7. Captain starts trip.
8. Location and trip state synchronise to Passenger and Operations.
9. Captain arrives at destination and completes the trip.
10. Backend calculates final fare and financial allocation.
11. Both parties receive completion records; Passenger may rate/report.

Alternative states: reject, expiry, Passenger no-show, Captain cancellation, location loss, app restart, destination change, payment failure, completion dispute.

## 6. Cash trip accounting

1. Passenger selected Cash before matching.
2. System assigned a cash-eligible Captain.
3. Passenger pays Captain directly after the completed trip.
4. System records gross fare, 10% TWALA commission, and 90% provider share.
5. Commission is posted against available provider funds when authorised, or becomes an outstanding obligation.
6. Eligibility is recalculated without duplicating the commission entry.

The system must not claim to have independently confirmed physical cash receipt unless a defined confirmation mechanism exists.

## 7. Cashless trip accounting

1. Passenger selected Cashless before matching.
2. Payment is initiated according to the approved collection timing.
3. PSP sends an authoritative success, failure, pending, or reversal result.
4. On confirmed success, ledger records gross fare, TWALA commission, provider share, processing charges where applicable, and settlement position.
5. Captain sees available or pending earnings; Operations sees reconciliation status.

Retries and repeated callbacks must not post duplicate money movements.

## 8. Deposit and withdrawal

### Deposit

1. User enters amount and chooses an approved channel.
2. System creates a unique pending transaction.
3. PSP processes and confirms the result.
4. Only confirmed success posts wallet credit.
5. Failed, pending, reversed, and disputed results remain separately visible.

### Withdrawal

1. User selects a registered destination and amount.
2. System validates identity/security, limits, fees, and available balance.
3. Funds are reserved.
4. PSP processes payout.
5. Success finalises the debit; failure/reversal releases or restores funds through ledger entries.

## 9. Complaint and safety report

1. Passenger selects a trip or creates a general report.
2. Passenger selects category/severity and provides details/evidence where allowed.
3. System issues a complaint reference.
4. Safety-classified reports follow an explicit escalation path.
5. Authorised staff assign, investigate, communicate, and resolve.
6. Status and resolution history remain traceable.

Emergency response must not be implied by the interface until staffing, operating hours, and escalation processes are approved.

## 10. Dashboard verification and finance controls

- Verification Officer may review and decide Captain applications but cannot silently alter wallet balances.
- Finance Officer may review transactions and reconciliation; adjustment and withdrawal approvals follow configured separation of duties.
- Operations Manager may monitor trips and operational restrictions but sees only permitted financial detail.
- Support Officer may manage complaints but cannot access unrelated identity or finance data.
- Read-only users cannot mutate operational or financial state.

