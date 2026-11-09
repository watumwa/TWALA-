# TWALA Initial Role and Permission Matrix

Legend: **M** manage/perform, **V** view, **A** separately approve, **—** no access. All access remains subject to operating-area and record-level scope.

| Capability | Super Admin | Operations Manager | Finance Officer | Verification Officer | Support Officer | Read-only |
|---|---:|---:|---:|---:|---:|---:|
| Dashboard configuration | M | V | — | — | — | — |
| Staff roles and permissions | M | V | — | — | — | — |
| Passenger profile/basic activity | M | M | Limited V | Limited V | M | V |
| Restrict/reactivate Passenger | M | M | — | — | Request | — |
| Captain profile/vehicle | M | M | Limited V | M | Limited V | V |
| Captain document review | V | V | — | M | — | — |
| Approve/reject Captain | A/M | A/M | — | M | — | — |
| Suspend/reactivate Captain | A/M | M | Request | Request | Request | — |
| Live map and active trips | V | M | — | Limited V | Limited V | V |
| Trip review and operational notes | M | M | Financial V | V | M | V |
| Fare draft | M | M | M | — | — | V |
| Fare publication | A/M | A | A | — | — | — |
| Wallet/account position | V | Summary V | M | — | Trip-limited V | Summary V |
| Ledger entries | V | Summary V | M | — | Trip-limited V | Summary V |
| Manual financial adjustment request | M | Request | M | — | Request | — |
| Manual financial adjustment approval | A | — | A, separate user | — | — | — |
| Withdrawal monitoring | V | Summary V | M | — | Status V | Summary V |
| Withdrawal approval | A by policy | — | M/A by separation | — | — | — |
| Reconciliation and settlement | V | Summary V | M | — | — | Summary V |
| Complaints | V | M | Financial V | Verification V | M | V |
| Safety escalation | V | M | — | Relevant V | M | Limited V |
| Notification templates | M | M | Finance templates | Verification templates | Support templates | V |
| Reports/exports | M | M | Finance exports | Verification exports | Support exports | Approved V |
| Audit history | V | Operational V | Financial V | Own actions V | Own actions V | Approved V |

## Rules that apply to every role

- Mobile and dashboard visibility never replaces backend permission checks.
- Users may access only the minimum personal, location, and financial data needed for their function.
- Staff cannot approve their own high-risk financial request where maker-checker control applies.
- Audit records cannot be edited or deleted through normal product functions.
- Sensitive exports are permissioned, watermarked/logged where practical, and have a defined retention policy.
- Break-glass access, if approved, requires a reason, additional authentication, immediate audit event, and review.
- Super Administrator is not an unrestricted finance role by default; production permission bundles must remain separable.

## Decisions still required

- Named approver roles and monetary thresholds.
- Whether Captain approval requires one or two reviewers.
- Operating-area scoping for staff.
- Which identity fields Support may view.
- Export formats, row limits, and approval requirements.
- Break-glass access policy and review owner.

