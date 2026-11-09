# TWALA Interactive Prototype

Phase 2 is a frontend-only product prototype. It uses deterministic demo data and does not connect to production identity, mapping, payment, wallet, or dispatch services.

## Applications

- `apps/customer_app` — Flutter Customer App prototype.
- `apps/captain_app` — Flutter Captain App prototype.
- `apps/operations_dashboard` — Next.js Operations Dashboard prototype.
- `packages/twala_ui` — shared Flutter visual system.
- `packages/twala_demo_core` — shared Flutter demo domain models.

## Toolchain

- Flutter 3.47.9 / Dart 3.13.7
- Node.js 22
- Next.js 16

The repository-local Flutter SDK under `.tooling/` is ignored by Git and exists only to make this workspace reproducible on the current machine.

## Run locally

From the repository root:

```bash
env PUB_CACHE="$PWD/.tooling/pub-cache" \
  XDG_CONFIG_HOME="$PWD/.tooling/config" \
  FLUTTER_SUPPRESS_ANALYTICS=true \
  .tooling/flutter/bin/flutter run \
  -d chrome \
  --project-dir twala-platform/apps/customer_app
```

For the Captain App, replace `customer_app` with `captain_app`.

Run the dashboard:

```bash
cd twala-platform/apps/operations_dashboard
npm run dev
```

## Prototype boundaries

- All balances, identities, routes, OTPs, payments, and locations are fictional.
- Maps are styled demo surfaces, not licensed routing or GPS integrations.
- Interactions demonstrate state and terminology for stakeholder approval.
- Production implementation begins only after requirements and prototype sign-off.

