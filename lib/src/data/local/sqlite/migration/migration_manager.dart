import 'package:sqflite/sqflite.dart';
import 'migrations/initial_migration.dart';

class MigrationManager {
  final Map<int, Future<void> Function(Database)> _migrations = {
    1: InitialMigration().createAllTables,
    // Add future migrations here:
    // 2: (db) => MigrationV2().upgrade(db),
    // 3: (db) => MigrationV3().upgrade(db),
  };

  Future<void> createAllTables(Database db) async {
    print(' Creating all initial tables...');
    await InitialMigration().createAllTables(db);
  }

  Future<void> migrate(Database db, int fromVersion, int toVersion) async {
    print('🔄 Running migrations from $fromVersion to $toVersion');

    for (int version = fromVersion + 1; version <= toVersion; version++) {
      if (_migrations.containsKey(version)) {
        print('📋 Applying migration to version $version');
        await _migrations[version]!(db);
      }
    }

    print('✅ All migrations completed successfully');
  }
}
