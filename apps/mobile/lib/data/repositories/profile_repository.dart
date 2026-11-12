import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../models/patient_profile.dart';

/// Repository for patient profiles (Care Circle foundation).
class ProfileRepository {
  final AppDatabase _db;
  ProfileRepository(this._db);

  Future<List<PatientProfile>> getAll() async {
    final db = await _db.db;
    final rows = await db.query(
      'patient_profiles',
      where: 'is_archived = 0',
      orderBy: 'created_at ASC',
    );
    return rows.map(PatientProfile.fromMap).toList();
  }

  Future<PatientProfile?> getById(String id) async {
    final db = await _db.db;
    final rows = await db.query(
      'patient_profiles',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : PatientProfile.fromMap(rows.first);
  }

  Future<PatientProfile> create({
    required String name,
    String relationship = 'self',
    String? dateOfBirth,
    String? allergies,
    String? conditions,
    String? bloodGroup,
    String? emergencyNotes,
  }) async {
    final now = DateTime.now().toIso8601String();
    final profile = PatientProfile(
      id: const Uuid().v4(),
      name: name,
      relationship: relationship,
      dateOfBirth: dateOfBirth,
      allergies: allergies,
      conditions: conditions,
      bloodGroup: bloodGroup,
      emergencyNotes: emergencyNotes,
    );
    final db = await _db.db;
    await db.insert('patient_profiles', {
      ...profile.toMap(),
      'created_at': now,
      'updated_at': now,
    });
    return profile;
  }

  Future<void> update(PatientProfile profile) async {
    final db = await _db.db;
    await db.update(
      'patient_profiles',
      {...profile.toMap(), 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<void> archive(String id) async {
    final db = await _db.db;
    await db.update(
      'patient_profiles',
      {'is_archived': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Ensures a default profile exists on first launch.
  Future<PatientProfile> ensureDefault() async {
    final all = await getAll();
    if (all.isNotEmpty) return all.first;
    return create(name: 'Me', relationship: 'self');
  }
}
