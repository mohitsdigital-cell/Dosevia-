import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../models/health.dart';

/// Repository for emergency contacts and care members
/// (Blueprint Parts 7.6, 7.1-7.3).
class EmergencyRepository {
  final AppDatabase _db;
  EmergencyRepository(this._db);

  Future<EmergencyContact> addContact({
    required String profileId,
    required String name,
    required String phone,
    String? relationship,
  }) async {
    final contact = EmergencyContact(
      id: const Uuid().v4(),
      profileId: profileId,
      name: name,
      phone: phone,
      relationship: relationship,
    );
    final db = await _db.db;
    await db.insert('emergency_contacts', contact.toMap());
    return contact;
  }

  Future<List<EmergencyContact>> contacts(String profileId) async {
    final db = await _db.db;
    final rows = await db.query(
      'emergency_contacts',
      where: 'profile_id = ?',
      whereArgs: [profileId],
    );
    return rows.map(EmergencyContact.fromMap).toList();
  }

  Future<void> removeContact(String id) async {
    final db = await _db.db;
    await db.delete('emergency_contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<CareMember> addMember({
    required String profileId,
    required String name,
    String? relationship,
    String permissionLevel = 'view',
  }) async {
    final member = CareMember(
      id: const Uuid().v4(),
      profileId: profileId,
      name: name,
      relationship: relationship,
      permissionLevel: permissionLevel,
    );
    final db = await _db.db;
    await db.insert('caregiver_links', member.toMap());
    return member;
  }

  Future<List<CareMember>> members(String profileId) async {
    final db = await _db.db;
    final rows = await db.query(
      'caregiver_links',
      where: 'profile_id = ? AND status != ?',
      whereArgs: [profileId, 'revoked'],
    );
    return rows.map(CareMember.fromMap).toList();
  }

  Future<void> revoke(String id) async {
    final db = await _db.db;
    await db.update(
      'caregiver_links',
      {'status': 'revoked'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
