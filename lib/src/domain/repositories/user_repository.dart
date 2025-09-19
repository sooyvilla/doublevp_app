import '../models/user.dart';

/// Repositorio abstracto para operaciones de `User`.
abstract class UserRepository {
  Future<List<User>> getAllUsers();
  Future<User> createUser(User user);
  Future<User?> getUserById(int id);
  Future<void> deleteUser(int id);
  Future<User> updateUser(User user);
}
