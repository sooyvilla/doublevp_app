import '../../data/models/user.dart';
import '../repositories/user_repository.dart';
import 'user_usecase.dart';

/// Caso de uso para crear un usuario.
class CreateUserUseCase implements UserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  @override
  Future<User> call(User user) async => await repository.createUser(user);
}
