import '../../data/models/user.dart';

/// Interfaz común para casos de uso que aceptan un [User] y retornan el usuario guardado.
abstract class UserUseCase {
  Future<User> call(User user);
}
