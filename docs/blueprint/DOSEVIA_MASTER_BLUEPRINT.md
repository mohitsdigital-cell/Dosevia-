# Dosevia Master Product Blueprint - v1.0

**Document Type:** Master Product Blueprint + PRD + Technical & Business Specification
**Project Name:** Dosevia
**Tagline:** Your Health. Your Family. One Connected Care.
**Project Status:** Greenfield - Building from Scratch
**Initial Market:** India
**Version:** 1.0 - Consolidated Master Blueprint
**Date:** 12 November 2026

## Summary

Dosevia is a Personal & Family Health Management Platform organised around four pillars:

1. **Pillar 1 - Medicine & Adherence**: medicine dashboard (morning/afternoon/evening/night), medicine management, prescription scanner (OCR + user confirmation), schedule builder, dose actions (take/skip/snooze/unavailable), medicine safety engine, stock and refill manager.
2. **Pillar 2 - Care Circle & Family Safety**: family profiles, secure invitations, granular permissions, pediatric dose safety, senior care, Emergency Medical ID, SOS (112 in India).
3. **Pillar 3 - Clinical Records & Diagnostics**: vitals, medical records hub, diagnostics partner hub, Retest Radar, Doctor Dossier.
4. **Pillar 4 - Wellness & Lifecycle**: six daily habits, 3D capsule mascot, Sleep Sanctuary, teen/pregnancy/senior/chronic-care hubs.

Plus: **Nurse Clara AI** (safety-first, never diagnoses or prescribes) and the **Health Timeline** (combined chronological record of all health events).

## Key architecture decisions

| Area | Decision |
|---|---|
| Mobile | Flutter, Dart, Riverpod, GoRouter, SQLite, local notifications |
| Backend | NestJS, TypeScript, PostgreSQL, modular monolith |
| Admin / Partner Portal | Next.js |
| AI | Provider-independent AI Gateway with safety checks |
| Data | FHIR R4-ready design; ABDM as future, approval-dependent track |
| Region | India-first (offline-first, Hindi + English, 112, PIN-code serviceability) |

## Development sequence (Part 40)

1. PRD -> 2. UI/UX prototype -> 3. ERD + API contracts -> 4. Greenfield repository -> 5. Medicine & Adherence MVP -> 6. Care Circle + Records + Emergency -> 7. Admin, security, clinical governance -> 8. Nurse Clara + diagnostics -> 9. Beta + launch -> 10. Wellness/ecosystem expansion.

This repository currently implements steps 4-6 (MVP) as an offline-first Flutter application. The complete original blueprint document (all 40 parts, database ERD, API list, task IDs DV-xxx, testing matrix and roadmap) is the project's single source of truth for future phases.

## MVP scope (Part 31)

**Included:** authentication foundation, profiles, medicine list, schedule builder, reminders, dose actions, dose history, family profiles, permissions model, basic vitals, document upload foundation, Medical ID, emergency contacts, offline schedules, audit-friendly immutable dose events, data export planning.

**Excluded:** full 3D mascot, pregnancy hub, all specialty hubs, national diagnostic partner APIs, autonomous AI decisions, unverified interaction data, ambulance dispatch, predictive scoring.
