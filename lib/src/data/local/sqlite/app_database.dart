import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'database_config.dart';
import 'migration/migration_manager.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DatabaseConfig.databaseName);

    print('📦 SQLite Database Path: $path');

    final database = await openDatabase(
      path,
      version: DatabaseConfig.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );

    // Apply configurations AFTER database is opened
    await _applyDatabaseConfig(database);

    return database;
  }

  Future<void> _applyDatabaseConfig(Database db) async {
    try {
      print('⚙️ Applying database performance configurations...');

      // Apply each configuration one by one
      await db.execute('PRAGMA journal_mode = WAL');
      print('✅ WAL mode enabled');

      await db.execute('PRAGMA cache_size = 10000');
      print('✅ Cache size set to 10MB');

      await db.execute('PRAGMA foreign_keys = ON');
      print('✅ Foreign keys enabled');

      await db.execute('PRAGMA temp_store = MEMORY');
      print('✅ Temp store set to memory');

      print('✅ All database configurations applied successfully');
    } catch (e) {
      print('⚠️ Warning: Some database configurations failed: $e');
      // Continue anyway - these are optimizations, not critical
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    print('🆕 Creating new database with version $version');

    // Apply config before creating tables
    await _applyDatabaseConfig(db);

    // Initialize all tables through migration manager
    final migrationManager = MigrationManager();
    await migrationManager.createAllTables(db);

    print('✅ Database created successfully with all tables');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('🔄 Upgrading database from $oldVersion to $newVersion');

    final migrationManager = MigrationManager();
    await migrationManager.migrate(db, oldVersion, newVersion);

    print('✅ Database upgraded successfully');
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    print('⚠️  Database downgrade not supported. Recreating database...');
    await _onCreate(db, newVersion);
  }

  // Helper methods for transactions
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction<T>(action);
  }

  // Close database connection
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      print('🔒 Database connection closed');
    }
  }

  // Delete database (for testing/reset)
  Future<void> deleteDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DatabaseConfig.databaseName);

    await close();
    await deleteDatabase(path);
    _database = null;

    print('🗑️ Database deleted');
  }
}
