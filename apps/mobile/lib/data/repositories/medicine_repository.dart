import 'package:uuid/uuid.dart';

import '../db/app_database.dart';
import '../models/medicine.dart';

/// Repository for medicines and their schedules (Blueprint Part 6.2).
class MedicineRepository {
  final AppDatabase _db;
  MedicineRepository(this._db);

  Future<List<Medicine>> getForProfile(String profileId) async {
    final db = await _db.db;
    final rows = await db.query(
      'medicines',
      where: 'profile_id = ? AND is_active = 1',
      whereArgs: [profileId],
      orderBy: 'name ASC',
    );
    return rows.map(Medicine.fromMap).toList();
  }

  Future<Medicine?> getById(String id) async {
    final db = await _db.db;
    final rows = await db.query('medicines',
        where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Medicine.fromMap(rows.first);
  }

  /// Creates a medicine together with its dose slots (Blueprint 6.4).
  Future<Medicine> create({
    required String profileId,
    required String name,
    String? brandName,
    String? strength,
    String? dosageForm,
    String? doseQuantity,
    String? instructions,
    String? notes,
    int? stock,
    required List<DoseSlot> slots,
  }) async {
    final medicine = Medicine(
      id: const Uuid().v4(),
      profileId: profileId,
      name: name,
      brandName: brandName,
      strength: strength,
      dosageForm: dosageForm,
      doseQuantity: doseQuantity,
      instructions: instructions,
      notes: notes,
      stock: stock,
    );

    final db = await _db.db;
    await db.insert('medicines', {
      ...medicine.toMap(),
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    final batch = db.batch();
    for (final slot in slots) {
      batch.insert('medicine_schedules', {
        'id': const Uuid().v4(),
        'medicine_id': medicine.id,
        'time_of_day': slot.name,
      });
    }
    await batch.commit(noResult: true);

    return medicine;
  }

  Future<List<DoseSlot>> getSlots(String medicineId) async {
    final db = await _db.db;
    final rows = await db.query('medicine_schedules',
        where: 'medicine_id = ?', whereArgs: [medicineId]);
    return rows
        .map((r) => DoseSlot.values.firstWhere((s) => s.name == r['time_of_day']))
        .toList();
  }

  Future<void> setSlots(String medicineId, List<DoseSlot> slots) async {
    final db = await _db.db;
    await db.delete('medicine_schedules',
        where: 'medicine_id = ?', whereArgs: [medicineId]);
    final batch = db.batch();
    for (final slot in slots) {
      batch.insert('medicine_schedules', {
        'id': const Uuid().v4(),
        'medicine_id': medicineId,
        'time_of_day': slot.name,
      });
    }
    await batch.commit(noResult: true);
  }

  /// Discontinue (Blueprint 6.2) - soft, keeps history intact.
  Future<void> discontinue(String id) async {
    final db = await _db.db;
    await db.update(
      'medicines',
      {'is_active': 0, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateStock(String id, int? stock) async {
    final db = await _db.db;
    await db.update(
      'medicines',
      {'stock': stock, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    final db = await _db.db;
    await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }
}
