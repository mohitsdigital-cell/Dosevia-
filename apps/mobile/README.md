# Dosevia Mobile App (Flutter)

MVP implementation of the Dosevia Master Blueprint v1.0 - Phase 2 (Core Engineering).

## Features

- Five-tab navigation: Home, Medicines, Health, Care Circle, Profile
- Add medicines with dose slots (morning/afternoon/evening/night)
- Take / Skip / Snooze dose actions with duplicate-take protection
- Dose history and daily adherence percentage
- Vitals recording (BP, glucose, HbA1c, weight, pulse, temperature, SpO2)
- Emergency Medical ID card with contacts
- Care Circle: family member profiles and active-profile switching
- English + Hindi UI, light/dark themes
- Offline-first: everything is stored in local SQLite

## Setup

The android folder is generated locally (kept out of version control).

```bash
flutter create . --platforms=android --org com.dosevia --project-name dosevia
```

Add permissions to `android/app/src/main/AndroidManifest.xml` (inside manifest, above application):

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

## Run

```bash
flutter pub get
flutter run               # device/emulator
flutter test              # unit tests
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`

## Structure

```text
lib/
  main.dart               # entry point
  core/                   # theme (brand colors), localised strings
  data/
    db/                   # SQLite schema
    models/               # Medicine, DoseEvent, Vital, Profile...
    repositories/         # data access layer
  services/               # notification scheduling
  state/                  # Riverpod providers
  ui/
    router.dart           # five-tab shell
    screens/              # home, medicines, health, care, profile
```

## Notes

- Dose events are immutable records (Blueprint 6.5); duplicates of "taken" for the same medicine+day are rejected.
- The app never advises an extra dose after a missed dose (Blueprint 6.5 safety rule).
- Nurse Clara, diagnostics booking, OCR and the backend arrive in later phases (Blueprint Parts 32, 40).
