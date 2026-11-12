import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../models/health.dart';

/// Repository for vitals (Blueprint Part 8.1).
class VitalsRepository {
  final AppDatabase _db;
  VitalsRepository(this._db);

  Future<Vital> record({
    required String profileId,
    required VitalType type,
    required double value,
    double? secondaryValue,
    String? note,
  }) async {
    final vital = Vital(
      id: const Uuid().v4(),
      profileId: profileId,
      type: type,
      value: value,
      secondaryValue: secondaryValue,
      recordedAt: DateTime.now(),
      note: note,
    );
    final db = await _db.db;
    await db.insert('vitals', vital.toMap());
    return vital;
  }

  Future<List<Vital>> forProfile(String profileId) async {
    final db = await _db.db;
    final rows = await db.query(
      'vitals',
      where: 'profile_id = ?',
      whereArgs: [profileId],
      orderBy: 'recorded_at DESC',
    );
    return rows.map(Vital.fromMap).toList();
  }

  Future<List<Vital>> forType(String profileId, VitalType type) async {
    final db = await _db.db;
    final rows = await db.query(
      'vitals',
      where: 'profile_id = ? AND type = ?',
      whereArgs: [profileId, type.name],
      orderBy: 'recorded_at DESC',
    );
    return rows.map(Vital.fromMap).toList();
  }
}
