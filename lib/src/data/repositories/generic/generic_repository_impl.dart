import 'package:hive/hive.dart';

import '../../../domain/repositories/generics/generic_repository.dart';

// Create a base interface that all entities must implement
abstract class EntityWithId {
  String get id;
}

class GenericRepositoryImpl<T extends EntityWithId>
    implements GenericRepository<T> {
  final Box<T> box;

  GenericRepositoryImpl(this.box);

  @override
  Future<List<T>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<T?> getById(String id) async {
    return box.get(id);
  }

  @override
  Future<List<T>> getByIds(List<String> ids) async {
    final entities = <T>[];
    for (final id in ids) {
      final entity = box.get(id);
      if (entity != null) {
        entities.add(entity);
      }
    }
    return entities;
  }

  @override
  Future<void> create(T entity) async {
    await box.put(entity.id, entity);
  }

  @override
  Future<void> update(T entity) async {
    await box.put(entity.id, entity);
  }

  @override
  Future<void> delete(String id) async {
    await box.delete(id);
  }

  @override
  Future<void> deleteAll() async {
    await box.clear();
  }

  @override
  Future<int> count() async {
    return box.length;
  }

  @override
  Stream<List<T>> watchAll() {
    return box.watch().map((event) => box.values.toList());
  }
}
