#!/usr/bin/env bash
# Dosevia mobile app - one-shot local setup (macOS/Linux)
# Generates the Android platform folder, injects required permissions,
# and installs dependencies.

set -euo pipefail

cd "$(dirname "$0")/../apps/mobile"

echo "==> Dosevia: generating Android platform files with flutter create ."
flutter create . --platforms=android --org com.dosevia --project-name dosevia

MANIFEST="android/app/src/main/AndroidManifest.xml"

echo "==> Adding Android permissions to $MANIFEST"
if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: AndroidManifest.xml not found. Is Flutter installed and on PATH?" >&2
  exit 1
fi

if ! grep -q "POST_NOTIFICATIONS" "$MANIFEST"; then
  # Insert permissions right after the opening <manifest ...> tag.
  perl -0pi -e 's/(<manifest[^>]*>)/$1\n    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" \/>\n    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" \/>\n/' "$MANIFEST"
  echo "    Added POST_NOTIFICATIONS + SCHEDULE_EXACT_ALARM permissions."
else
  echo "    Permissions already present."
fi

echo "==> Installing Dart dependencies"
flutter pub get

echo
echo "Setup complete. Now run:"
echo "  flutter run        # debug on device/emulator"
echo "  flutter build apk  # build the APK"
