import '../../data/models/user.dart';
import '../repositories/user_repository.dart';
import 'user_usecase.dart';

class UpdateUserUseCase implements UserUseCase {
  final UserRepository repository;
  UpdateUserUseCase(this.repository);

  @override
  Future<User> call(User user) async => await repository.updateUser(user);
}
