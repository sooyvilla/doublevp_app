import 'package:isar/isar.dart';

import '../../domain/repositories/user_repository.dart';
import '../models/user.dart';

/// Implementación de `UserRepository` usando Isar.
class IsarUserRepository implements UserRepository {
  final Future<Isar> Function() _isarFactory;

  IsarUserRepository(this._isarFactory);

  Future<Isar> get _db async => await _isarFactory();

  @override
  Future<User> createUser(User user) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
    return user;
  }

  @override
  Future<void> deleteUser(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.users.delete(id);
    });
  }

  @override
  Future<List<User>> getAllUsers() async {
    final isar = await _db;
    return await isar.users.where().findAll();
  }

  @override
  Future<User?> getUserById(int id) async {
    final isar = await _db;
    return await isar.users.get(id);
  }
}
