// class DatabaseConfig {
//   // Database version - increment when you change schema
//   static const int databaseVersion = 1;

//   // Database name
//   static const String databaseName = 'pos_database.db';

//   // Performance optimizations
//   static const String walMode = 'PRAGMA journal_mode = WAL';
//   static const String cacheSize = 'PRAGMA cache_size = 10000';
//   static const String foreignKeys = 'PRAGMA foreign_keys = ON';
//   static const String tempStore = 'PRAGMA temp_store = MEMORY';

//   // Get all configuration commands
//   static List<String> get configCommands => [
//     walMode,
//     cacheSize,
//     foreignKeys,
//     tempStore,
//   ];
// }
class DatabaseConfig {
  // Database version - increment when you change schema
  static const int databaseVersion = 1;

  // Database name
  static const String databaseName = 'pos_database.db';

  // Performance optimizations (as strings for direct execution)
  static const List<String> configCommands = [
    'PRAGMA journal_mode = WAL',
    'PRAGMA cache_size = 10000',
    'PRAGMA foreign_keys = ON',
    'PRAGMA temp_store = MEMORY',
  ];
}
