import '../../../data/repositories/generic/generic_repository_impl.dart';

abstract class GenericRepository<T extends EntityWithId> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<List<T>> getByIds(List<String> ids);
  Future<void> create(T entity);
  Future<void> update(T entity);
  Future<void> delete(String id);
  Future<void> deleteAll();
  Future<int> count();
  Stream<List<T>> watchAll();
}
