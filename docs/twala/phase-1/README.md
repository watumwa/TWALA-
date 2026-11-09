# TWALA Phase 1 Foundation

Status: Draft v0.1 for stakeholder review  
Prepared: 9 November 2026  
Source: TWALA Master Technical Development Discussion Document

## Purpose

This folder converts the client's discussion document into a practical starting point for product design and delivery. It does not treat the discussion document as a final Software Requirements Specification (SRS). Items that still require business, legal, financial, or operational approval are recorded as open decisions.

Phase 1 does not implement live payments, wallets, matching, or GPS tracking. Its output is the approved definition of what will be built and the interaction model that the frontend prototype will demonstrate.

## Documents

- [SRS_DRAFT.md](SRS_DRAFT.md) — product scope, requirements, business rules, non-functional requirements, and acceptance baseline.
- [DECISION_REGISTER.md](DECISION_REGISTER.md) — approved decisions, assumptions, and questions that must be answered before production development.
- [USER_JOURNEYS.md](USER_JOURNEYS.md) — end-to-end Customer, Captain, and Operations workflows.
- [SOLUTION_BLUEPRINT.md](SOLUTION_BLUEPRINT.md) — proposed architecture, core data boundaries, state models, and security approach.
- [INTERACTIVE_PROTOTYPE_PLAN.md](INTERACTIVE_PROTOTYPE_PLAN.md) — the frontend-first screen inventory, demo behavior, schedule, and acceptance criteria.
- [ROLE_PERMISSION_MATRIX.md](ROLE_PERMISSION_MATRIX.md) — initial separation of dashboard and system responsibilities.
- [TRACEABILITY_MATRIX.md](TRACEABILITY_MATRIX.md) — mapping from requirement groups to prototype screens, scenarios, and later production evidence.

## Reuse strategy

TWALA will not be built by rewriting every technical capability from first principles. The project should reuse:

- Current stable Flutter and maintained packages for maps, camera/QR, secure storage, networking, notifications, and local persistence.
- Managed mapping, SMS/OTP, push notification, object storage, and monitoring services.
- A licensed payment service provider for regulated money movement.
- Shared design-system and domain packages between the Customer and Captain apps.
- Existing visual references only after checking ownership and brand suitability.

The legacy SafeBoda UI demo at the repository root remains reference material only. It is a pre-null-safety sample and must not become the TWALA production foundation.

## Phase 1 exit gate

Phase 1 is complete only when TWALA signs off:

1. The SRS scope and terminology.
2. Critical booking, trip, payment, wallet, and complaint workflows.
3. The first-release scope and explicitly deferred features.
4. The prototype screen list and visual direction.
5. The proposed architecture and third-party integration approach.
6. Open financial and regulatory decisions, or named owners and deadlines for resolving them.
7. Measurable acceptance criteria and a milestone-based delivery plan.
