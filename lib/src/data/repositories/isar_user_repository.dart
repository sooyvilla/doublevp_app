import 'package:isar/isar.dart';

import '../../domain/repositories/user_repository.dart';
import '../../domain/models/address.dart';
import '../../domain/models/user.dart';

/// Implementación de `UserRepository` usando Isar.
class IsarUserRepository implements UserRepository {
  final Future<Isar> Function() _isarFactory;

  IsarUserRepository(this._isarFactory);

  Future<Isar> get _db async => await _isarFactory();

  @override
  Future<User> createUser(User user) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      final addressesToLink = user.addresses.toList();

      for (final a in addressesToLink) {
        await isar.collection<Address>().put(a);
      }

      await isar.collection<User>().put(user);

      final savedUser = await isar.collection<User>().get(user.id);
      if (savedUser != null) {
        savedUser.addresses.clear();
        savedUser.addresses.addAll(addressesToLink);
        await savedUser.addresses.save();
      }
    });
    return user;
  }

  @override
  Future<void> deleteUser(int id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.collection<User>().delete(id);
    });
  }

  @override
  Future<List<User>> getAllUsers() async {
    final isar = await _db;
    final users = await isar.collection<User>().where().findAll();

    for (final u in users) {
      await u.addresses.load();
    }
    return users;
  }

  @override
  Future<User?> getUserById(int id) async {
    final isar = await _db;
    final user = await isar.collection<User>().get(id);
    if (user != null) await user.addresses.load();
    return user;
  }

  @override
  Future<User> updateUser(User user) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      final addressesToLink = user.addresses.toList();

      for (final a in addressesToLink) {
        await isar.collection<Address>().put(a);
      }

      await isar.collection<User>().put(user);

      final savedUser = await isar.collection<User>().get(user.id);
      if (savedUser != null) {
        savedUser.addresses.clear();
        savedUser.addresses.addAll(addressesToLink);
        await savedUser.addresses.save();
      }
    });
    return user;
  }
}
