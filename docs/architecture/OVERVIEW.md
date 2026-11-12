# Dosevia Architecture Overview

**Status:** MVP shipped (Phase 2 Core Engineering) - next phases pending.

## Current state (this repository)

```text
Dosevia-/
  apps/mobile/          Flutter MVP - offline-first
  docs/                blueprint + architecture
  scripts/             setup helpers
  .github/workflows/   CI (flutter analyze + test)
```

### MVP mobile architecture

| Layer | Contents |
|---|---|
| lib/core | Design tokens (brand colors, light/dark themes), localised strings (EN/HI) |
| lib/data/db | SQLite schema: patient_profiles, medicines, medicine_schedules, dose_events, vitals, emergency_contacts, caregiver_links |
| lib/data/models | Medicine, DoseEvent, Vital, EmergencyContact, CareMember, PatientProfile |
| lib/data/repositories | Profile, Medicine, Adherence, Vitals, Emergency repositories |
| lib/services | NotificationService (daily medicine reminders) |
| lib/state | Riverpod providers (db, repos, locale, theme, active profile) |
| lib/ui | Five-tab shell: Home, Medicines, Health, Care Circle, Profile |

### Safety rules implemented

- Duplicate taken dose for the same medicine on the same day is rejected (Blueprint 7.4).
- Dose events are immutable; skipping or snoozing never creates an extra-dose suggestion (Blueprint 6.5).
- Emergency Medical ID surfaces allergies, conditions and 112 guidance (Blueprint 7.6/7.7).
- Disclaimers keep Dosevia a health-organisation tool, never a clinician (Blueprint 2.4, 10.4).

## Target architecture (from blueprint Part 18)

- **Backend:** NestJS + PostgreSQL modular monolith (auth, profiles, medicines, family, records, diagnostics, AI gateway, notifications, consent, audit).
- **Admin Dashboard and Partner Portal:** Next.js.
- **AI:** provider-independent gateway with retrieval, safety classification, source attribution.
- **Integrations:** Health Connect/HealthKit, FCM, payments via adapters, diagnostics partners (API / portal / referral models), ABDM (future, approval-dependent).

## Next development steps

| Phase | Tasks |
|---|---|
| Phase 2 remainder | Notification permission flow + schedule reminders on medicine create (DV-MED-007), prescription upload UI (DV-MED-004), dose timeline per slot (DV-MED-006) |
| Phase 3 | Care Circle invitations + permissions UI (DV-FAM-002..010), document upload + Health Timeline (DV-REC-005..008), Doctor Dossier (DV-REC-010) |
| Phase 4 | Backend foundation (NestJS, PostgreSQL), AI Gateway, Clara, diagnostics directory + partner portal |
| Phase 5 | QA, security, accessibility, AI safety evaluation |
| Phase 6 | Production infra, monitoring, store release |

Task IDs follow the Developer Backlog in the Master Blueprint (Part 33).
