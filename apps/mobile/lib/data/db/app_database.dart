import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// Offline-first SQLite database (Blueprint Part 27).
/// Core MVP tables mirror the Master Blueprint Part 19 entities.
class AppDatabase {
  static const _version = 1;

  Database? _db;

  Future<Database> get db async => _db ??= await _open();

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'dosevia.db');
    return openDatabase(
      path,
      version: _version,
      onCreate: (db, v) async {
        final batch = db.batch();
        _createTables(batch);
        await batch.commit(noResult: true);
      },
    );
  }

  void _createTables(Batch batch) {
    batch.execute('''
      CREATE TABLE patient_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        relationship TEXT NOT NULL DEFAULT 'self',
        date_of_birth TEXT,
        allergies TEXT,
        conditions TEXT,
        blood_group TEXT,
        emergency_notes TEXT,
        is_archived INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    batch.execute('''
      CREATE TABLE medicines (
        id TEXT PRIMARY KEY,
        profile_id TEXT NOT NULL,
        name TEXT NOT NULL,
        brand_name TEXT,
        strength TEXT,
        dosage_form TEXT,
        dose_quantity TEXT,
        instructions TEXT,
        notes TEXT,
        stock INTEGER,
        is_active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (profile_id) REFERENCES patient_profiles (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE medicine_schedules (
        id TEXT PRIMARY KEY,
        medicine_id TEXT NOT NULL,
        time_of_day TEXT NOT NULL,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE dose_events (
        id TEXT PRIMARY KEY,
        medicine_id TEXT NOT NULL,
        profile_id TEXT NOT NULL,
        scheduled_at TEXT NOT NULL,
        action TEXT NOT NULL,
        recorded_at TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (medicine_id) REFERENCES medicines (id),
        FOREIGN KEY (profile_id) REFERENCES patient_profiles (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE vitals (
        id TEXT PRIMARY KEY,
        profile_id TEXT NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        secondary_value REAL,
        unit TEXT NOT NULL,
        recorded_at TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (profile_id) REFERENCES patient_profiles (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE emergency_contacts (
        id TEXT PRIMARY KEY,
        profile_id TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        relationship TEXT,
        FOREIGN KEY (profile_id) REFERENCES patient_profiles (id)
      )
    ''');

    batch.execute('''
      CREATE TABLE caregiver_links (
        id TEXT PRIMARY KEY,
        profile_id TEXT NOT NULL,
        member_name TEXT NOT NULL,
        relationship TEXT,
        permission_level TEXT NOT NULL DEFAULT 'view',
        status TEXT NOT NULL DEFAULT 'active',
        invited_at TEXT NOT NULL,
        FOREIGN KEY (profile_id) REFERENCES patient_profiles (id)
      )
    ''');

    batch.execute('CREATE INDEX idx_medicines_profile ON medicines (profile_id)');
    batch.execute('CREATE INDEX idx_dose_events_profile ON dose_events (profile_id, scheduled_at)');
    batch.execute('CREATE INDEX idx_vitals_profile ON vitals (profile_id, type)');
    batch.execute('CREATE INDEX idx_dose_events_dedup ON dose_events (medicine_id, scheduled_at, action)');
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
