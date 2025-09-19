import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/hive_user_repository.dart';
import '../domain/repositories/user_repository.dart';

/// Proveedor del repositorio de usuarios (Hive-backed).
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return HiveUserRepository();
});
