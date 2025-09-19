import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/models.dart';
import '../data/repositories/isar_user_repository.dart';
import '../domain/repositories/user_repository.dart';

/// Proveedor que abre la instancia de Isar.
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    UserSchema,
    AddressSchema,
  ], directory: dir.path);
  return isar;
});

/// Proveedor del repositorio de usuarios.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return IsarUserRepository(() => ref.watch(isarProvider.future));
});
