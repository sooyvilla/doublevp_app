import '../../data/models/user.dart';
import '../repositories/user_repository.dart';

class GetUserByIdUseCase {
  final UserRepository repository;
  GetUserByIdUseCase(this.repository);

  Future<User?> call(int id) async => await repository.getUserById(id);
}
