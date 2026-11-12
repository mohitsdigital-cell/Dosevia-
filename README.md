# Dosevia

**Your Health. Your Family. One Connected Care.**

Dosevia is a Personal & Family Health Management Platform (India-first, Android-first). This repository contains the greenfield MVP implementation of the Dosevia Master Blueprint v1.0.

> ⚠️ **Health disclaimer:** Dosevia is a health-organisation tool — not a medical device, hospital, doctor or pharmacy. It does not diagnose, prescribe or replace professional medical care. In an emergency in India, call **112**.

---

## Repository layout

```text
Dosevia-/
├── apps/
│   └── mobile/           # Flutter app (this MVP)
├── docs/
│   ├── blueprint/        # Dosevia Master Blueprint v1.0
│   └── architecture/     # Architecture overview & roadmap
├── scripts/
│   └── setup_mobile.sh   # One-shot local Android setup helper
└── .github/workflows/    # CI: flutter analyze + flutter test
```

Backend (`backend/`), Admin Dashboard (`apps/admin`) and Partner Portal (`apps/partner-portal`) arrive in later phases — see `docs/architecture/OVERVIEW.md`.

## MVP features (Phase 2 — Core Engineering)

| Pillar | Features in this MVP |
|---|---|
| Medicine & Adherence | Add/edit medicines, flexible daily schedules (morning/afternoon/evening/night), local reminders, Take / Skip / Snooze dose actions, dose history, stock tracking, daily adherence |
| Care Circle | Multi-member family profiles, member switching, invitation preview (local), permission model documentation |
| Clinical Records | Vitals (BP, glucose, weight, pulse, temperature, SpO2) with history, Emergency Medical ID with contacts, JSON data export |
| Emergency | Emergency contact list, one-tap dial, India emergency number 112 |
| Platform | Offline-first SQLite storage, English + हिन्दी UI, dark mode, unit tests, CI |

Excluded from MVP per the blueprint (Part 31.2): 3D mascot, pregnancy hub, partner APIs, autonomous AI decisions, ambulance dispatch.

## Run it on Android

**Prerequisites:** [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel), Android device/emulator, Git.

```bash
git clone https://github.com/mohitsdigital-cell/Dosevia-.git
cd Dosevia-

# One-shot setup (macOS/Linux): generates local Android files + permissions + deps
./scripts/setup_mobile.sh

# or manually:
cd apps/mobile
flutter create . --platforms=android --org com.dosevia --project-name dosevia
# then add the permissions below to android/app/src/main/AndroidManifest.xml
flutter pub get
```

Add inside `<manifest>` (above `<application>`):

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

Then:

```bash
flutter run                  # debug run on a connected device
flutter test                 # unit tests
flutter build apk --release  # APK: build/app/outputs/flutter-apk/app-release.apk
```

> Android/iOS platform folders (`apps/mobile/android/`, `apps/mobile/ios/`) are generated locally with `flutter create` and kept out of version control. Windows users: follow the same manual steps (see `apps/mobile/README.md`).

## Documentation

- `docs/blueprint/DOSEVIA_MASTER_BLUEPRINT.md` — the complete Master Blueprint v1.0 (PRD, features, database, API, roadmap)
- `docs/architecture/OVERVIEW.md` — MVP architecture and next phases

## Branching

Development happens on the `development` branch; `main` receives reviewed merges.

## License

Proprietary — © 2026 Dosevia. All rights reserved.
