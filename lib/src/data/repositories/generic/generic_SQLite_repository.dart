import 'package:sqflite/sqflite.dart';
import 'package:muaath_start_point_project/src/data/local/sqlite/app_database.dart';

import '../../../domain/repositories/generics/generic_repository.dart';
import 'generic_repository_impl.dart';

// Mapper interface for converting between Dart objects and database maps
abstract class EntityMapper<T extends EntityWithId> {
  String get tableName;
  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap(T entity);
}

class SQLiteGenericRepository<T extends EntityWithId>
    implements GenericRepository<T> {
  final AppDatabase _database;
  final EntityMapper<T> _mapper;

  SQLiteGenericRepository(this._database, this._mapper);

  @override
  Future<List<T>> getAll() async {
    final db = await _database.database;
    try {
      final results = await db.query(_mapper.tableName);
      return results.map((map) => _mapper.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting all from ${_mapper.tableName}: $e');
      return [];
    }
  }

  @override
  Future<T?> getById(String id) async {
    final db = await _database.database;
    try {
      final results = await db.query(
        _mapper.tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return results.isNotEmpty ? _mapper.fromMap(results.first) : null;
    } catch (e) {
      print('❌ Error getting by id from ${_mapper.tableName}: $e');
      return null;
    }
  }

  @override
  Future<List<T>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final db = await _database.database;
    try {
      // Create placeholders for the IN clause: ?, ?, ?
      final placeholders = List.filled(ids.length, '?').join(',');

      final results = await db.query(
        _mapper.tableName,
        where: 'id IN ($placeholders)',
        whereArgs: ids,
      );
      return results.map((map) => _mapper.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting by ids from ${_mapper.tableName}: $e');
      return [];
    }
  }

  @override
  Future<void> create(T entity) async {
    final db = await _database.database;
    try {
      await db.insert(
        _mapper.tableName,
        _mapper.toMap(entity),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      print('✅ Created ${entity.runtimeType} with id: ${entity.id}');
    } catch (e) {
      print('❌ Error creating in ${_mapper.tableName}: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(T entity) async {
    final db = await _database.database;
    try {
      await db.update(
        _mapper.tableName,
        _mapper.toMap(entity),
        where: 'id = ?',
        whereArgs: [entity.id],
      );
      print('✅ Updated ${entity.runtimeType} with id: ${entity.id}');
    } catch (e) {
      print('❌ Error updating in ${_mapper.tableName}: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    final db = await _database.database;
    try {
      await db.delete(_mapper.tableName, where: 'id = ?', whereArgs: [id]);
      print('✅ Deleted from ${_mapper.tableName} with id: $id');
    } catch (e) {
      print('❌ Error deleting from ${_mapper.tableName}: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAll() async {
    final db = await _database.database;
    try {
      await db.delete(_mapper.tableName);
      print('✅ Cleared all data from ${_mapper.tableName}');
    } catch (e) {
      print('❌ Error clearing ${_mapper.tableName}: $e');
      rethrow;
    }
  }

  @override
  Future<int> count() async {
    final db = await _database.database;
    try {
      final results = await db.rawQuery(
        'SELECT COUNT(*) as count FROM ${_mapper.tableName}',
      );
      return results.first['count'] as int;
    } catch (e) {
      print('❌ Error counting ${_mapper.tableName}: $e');
      return 0;
    }
  }

  @override
  Stream<List<T>> watchAll() {
    // SQLite doesn't have built-in change streams like Hive
    // We'll implement this with periodic polling or use a StreamController
    // For now, return an empty stream that can be enhanced later
    return Stream.empty();
  }

  // Additional useful methods for SQLite

  Future<List<T>> getWhere(String where, List<dynamic> whereArgs) async {
    final db = await _database.database;
    try {
      final results = await db.query(
        _mapper.tableName,
        where: where,
        whereArgs: whereArgs,
      );
      return results.map((map) => _mapper.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error querying ${_mapper.tableName}: $e');
      return [];
    }
  }

  Future<T?> getFirstWhere(String where, List<dynamic> whereArgs) async {
    final results = await getWhere(where, whereArgs);
    return results.isNotEmpty ? results.first : null;
  }

  Future<void> createAll(List<T> entities) async {
    final db = await _database.database;
    final batch = db.batch();

    try {
      for (final entity in entities) {
        batch.insert(
          _mapper.tableName,
          _mapper.toMap(entity),
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
      }
      await batch.commit(noResult: true);
      print('✅ Created ${entities.length} entities in ${_mapper.tableName}');
    } catch (e) {
      print('❌ Error batch creating in ${_mapper.tableName}: $e');
      rethrow;
    }
  }

  Future<void> updateAll(List<T> entities) async {
    final db = await _database.database;
    final batch = db.batch();

    try {
      for (final entity in entities) {
        batch.update(
          _mapper.tableName,
          _mapper.toMap(entity),
          where: 'id = ?',
          whereArgs: [entity.id],
        );
      }
      await batch.commit(noResult: true);
      print('✅ Updated ${entities.length} entities in ${_mapper.tableName}');
    } catch (e) {
      print('❌ Error batch updating in ${_mapper.tableName}: $e');
      rethrow;
    }
  }
}
