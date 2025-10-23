import 'app_database.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  final AppDatabase _appDatabase = AppDatabase();
  bool _isInitialized = false;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> initialize() async {
    if (_isInitialized) {
      print('✅ Database already initialized');
      return;
    }

    try {
      print('🚀 Initializing SQLite Database...');

      // This will trigger database creation/opening
      final database = await _appDatabase.database;

      // Test the connection with a simple query
      final result = await database.rawQuery('SELECT 1 as test');
      final testValue = result.first['test'];

      if (testValue == 1) {
        _isInitialized = true;
        print('✅ SQLite Database initialized successfully');

        // Get database info
        final version = await database.rawQuery(
          'SELECT sqlite_version() as version',
        );
        print('📊 SQLite Version: ${version.first['version']}');

        // Check if our test table exists
        final tables = await database.rawQuery('''
          SELECT name FROM sqlite_master 
          WHERE type='table' AND name='app_metadata'
        ''');

        if (tables.isNotEmpty) {
          print('✅ Test table verified successfully');
        }
      }
    } catch (e) {
      print('❌ Database initialization failed: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  AppDatabase get appDatabase => _appDatabase;

  bool get isInitialized => _isInitialized;

  Future<void> close() async {
    await _appDatabase.close();
    _isInitialized = false;
  }

  Future<void> reset() async {
    await _appDatabase.deleteDB();
    _isInitialized = false;
    await initialize();
  }
}
