import 'package:sqflite/sqflite.dart';

class InitialMigration {
  Future<void> createAllTables(Database db) async {
    print('📋 Creating initial tables structure...');

    // We'll add table creation SQL here one by one
    // For now, just create a simple table to test the setup

    await _createTestTable(db);

    print('✅ Initial tables created successfully');
  }

  Future<void> _createTestTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_metadata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Insert initial metadata
    await db.insert('app_metadata', {
      'key': 'database_version',
      'value': '1',
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });

    print('✅ Test table (app_metadata) created');
  }
}
