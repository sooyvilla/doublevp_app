import '../../data/models/user.dart';
import '../repositories/user_repository.dart';

class GetAllUsersUseCase {
  final UserRepository repository;
  GetAllUsersUseCase(this.repository);

  Future<List<User>> call() async => await repository.getAllUsers();
}
