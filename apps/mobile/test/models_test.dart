import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:dosevia/core/app_strings.dart';
import 'package:dosevia/data/models/medicine.dart';
import 'package:dosevia/data/models/health.dart';
import 'package:dosevia/data/models/patient_profile.dart';

void main() {
  group('DoseSlot', () {
    test('default hours are sensible for the four slots', () {
      expect(DoseSlot.morning.defaultHour, 8);
      expect(DoseSlot.afternoon.defaultHour, 13);
      expect(DoseSlot.evening.defaultHour, 18);
      expect(DoseSlot.night.defaultHour, 22);
    });

    test('labels cover all four slots', () {
      expect(DoseSlot.values.map((s) => s.label).toSet().length, 4);
    });
  });

  group('DoseEvent', () {
    test('serialises and deserialises correctly', () {
      final now = DateTime(2026, 11, 12, 8);
      final event = DoseEvent(
        id: 'e1',
        medicineId: 'm1',
        profileId: 'p1',
        scheduledAt: now,
        action: DoseAction.taken,
        recordedAt: now,
      );

      final restored = DoseEvent.fromMap(event.toMap());
      expect(restored.action, DoseAction.taken);
      expect(restored.scheduledAt, now);
      expect(restored.medicineId, 'm1');
    });
  });

  group('Vital', () {
    test('blood pressure displays systolic/diastolic', () {
      final vital = Vital(
        id: 'v1',
        profileId: 'p1',
        type: VitalType.bloodPressure,
        value: 120,
        secondaryValue: 80,
        recordedAt: DateTime(2026, 11, 12),
      );
      expect(vital.displayValue, '120/80 mmHg');
    });

    test('single-value vitals display value and unit', () {
      final vital = Vital(
        id: 'v2',
        profileId: 'p1',
        type: VitalType.weight,
        value: 68.5,
        recordedAt: DateTime(2026, 11, 12),
      );
      expect(vital.displayValue, '68.5 kg');
    });
  });

  group('PatientProfile', () {
    test('copyWith preserves untouched fields', () {
      final profile = PatientProfile(
        id: 'p1',
        name: 'Me',
        relationship: 'self',
        allergies: 'Penicillin',
      );
      final updated = profile.copyWith(name: 'Mohit');
      expect(updated.name, 'Mohit');
      expect(updated.allergies, 'Penicillin');
      expect(updated.relationship, 'self');
    });
  });

  group('AppStrings', () {
    test('English and Hindi greetings differ', () {
      const en = Locale('en');
      const hi = Locale('hi');
      expect(
          AppStrings.greetingMorning(en) == AppStrings.greetingMorning(hi),
          isFalse);
    });
  });
}
