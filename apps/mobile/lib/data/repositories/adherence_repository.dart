import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../models/medicine.dart';

/// Records dose events and computes adherence (Blueprint Parts 6.5, 6.1).
class AdherenceRepository {
  final AppDatabase _db;
  AdherenceRepository(this._db);

  /// Records a dose action.
  ///
  /// Duplicate-dose protection (Blueprint 7.4 / 34.2 scenario 1):
  /// if the same medicine + slot was already recorded as taken today,
  /// the call returns null instead of inserting a second taken event.
  Future<DoseEvent?> recordDose({
    required Medicine medicine,
    required DoseSlot slot,
    required DoseAction action,
    String? note,
  }) async {
    if (action == DoseAction.taken) {
      final alreadyTaken = await _hasTakenToday(medicine.id, slot);
      if (alreadyTaken) return null;
    }

    final now = DateTime.now();
    final scheduledAt = DateTime(now.year, now.month, now.day, slot.defaultHour);

    final event = DoseEvent(
      id: const Uuid().v4(),
      medicineId: medicine.id,
      profileId: medicine.profileId,
      scheduledAt: scheduledAt,
      action: action,
      recordedAt: now,
      note: note,
    );

    final db = await _db.db;
    await db.insert('dose_events', event.toMap());

    // Stock decreases when a dose is taken and stock is tracked (Blueprint 6.7).
    if (action == DoseAction.taken && medicine.stock != null && medicine.stock! > 0) {
      await db.update(
        'medicines',
        {'stock': medicine.stock! - 1},
        where: 'id = ?',
        whereArgs: [medicine.id],
      );
    }

    return event;
  }

  Future<bool> _hasTakenToday(String medicineId, DoseSlot slot) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).toIso8601String();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();

    final db = await _db.db;
    final rows = await db.query(
      'dose_events',
      where:
          'medicine_id = ? AND action = ? AND scheduled_at >= ? AND scheduled_at <= ?',
      whereArgs: [medicineId, DoseAction.taken.name, start, end],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// All dose events for a profile on a given date.
  Future<List<DoseEvent>> eventsForDay(String profileId, DateTime day) async {
    final start = DateTime(day.year, day.month, day.day).toIso8601String();
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59).toIso8601String();
    final db = await _db.db;
    final rows = await db.query(
      'dose_events',
      where: 'profile_id = ? AND scheduled_at >= ? AND scheduled_at <= ?',
      whereArgs: [profileId, start, end],
      orderBy: 'scheduled_at ASC',
    );
    return rows.map(DoseEvent.fromMap).toList();
  }

  /// Daily adherence summary (Blueprint 6.1).
  ///
  /// adherence = taken / (taken + skipped).
  /// Snoozed and unavailable doses are excluded from the denominator.
  /// Returns 0 when nothing was recorded yet.
  Future<double> adherenceForDay(String profileId, DateTime day) async {
    final events = await eventsForDay(profileId, day);
    final taken = events.where((e) => e.action == DoseAction.taken).length;
    final skipped = events.where((e) => e.action == DoseAction.skipped).length;
    final denominator = taken + skipped;
    return denominator == 0 ? 0 : taken / denominator;
  }

  /// Full history for a profile (most recent first).
  Future<List<DoseEvent>> history(String profileId, {int limit = 200}) async {
    final db = await _db.db;
    final rows = await db.query(
      'dose_events',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'recorded_at DESC',
      limit: limit,
    );
    return rows.map(DoseEvent.fromMap).toList();
  }
}
