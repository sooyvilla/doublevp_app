import '../../data/models/user.dart';
import '../repositories/user_repository.dart';

/// Caso de uso para crear un usuario.
class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<User> call(User user) async {
    return await repository.createUser(user);
  }
}
