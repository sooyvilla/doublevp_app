import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/address.dart';
import '../../domain/models/user.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/usecases/update_user_usecase.dart';
import '../../domain/usecases/user_usecase.dart';

/// Provider para los use-cases. Se construyen desde el repo central.
final createUserUseCaseNotifier = Provider<CreateUserUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return CreateUserUseCase(repo);
});

final updateUserUseCaseNotifier = Provider<UpdateUserUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UpdateUserUseCase(repo);
});

final getUserByIdUseCaseNotifier = Provider<GetUserByIdUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return GetUserByIdUseCase(repo);
});

/// Controlador del formulario de usuario integrado como FamilyAsyncNotifier.
class UserFormNotifier extends FamilyAsyncNotifier<void, int?> {
  late UserUseCase _useCase;
  final _addresses = <Address>[];
  User? _loadedUser;

  User? get loadedUser => _loadedUser;

  List<Address> get addresses => List.unmodifiable(_addresses);

  @override
  Future<void> build(int? userId) async {
    // Inyectar caso de uso según si es creación o actualización
    if (userId == null) {
      final c = ref.read(createUserUseCaseNotifier);
      _useCase = c;
    } else {
      final u = ref.read(updateUserUseCaseNotifier);
      _useCase = u;
    }

    if (userId != null) {
      final getUser = ref.read(getUserByIdUseCaseNotifier);
      final u = await getUser.call(userId);
      await loadUser(u);
    }
  }

  Future<void> loadUser(User? user) async {
    if (user == null) return;
    state = const AsyncValue.loading();
    try {
      await user.addresses.load();
      _addresses
        ..clear()
        ..addAll(user.addresses.toList());
      _loadedUser = user;
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addAddress(Address a) {
    _addresses.add(a);
    // trigger listeners
    state = const AsyncValue.data(null);
  }

  Future<void> submit(User user) async {
    state = const AsyncValue.loading();
    try {
      user.addresses.clear();
      user.addresses.addAll(_addresses);
      await _useCase.call(user);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider auxiliar que expone la lista de direcciones del notifier.
final userFormAddressesNotifierFamily = Provider.family<List<Address>, int?>((
  ref,
  userId,
) {
  ref.watch(userFormNotifier(userId));
  final notifier = ref.read(userFormNotifier(userId).notifier);
  return notifier.addresses;
});

final userFormLoadedUserNotifier = Provider.family<User?, int?>((ref, userId) {
  ref.watch(userFormNotifier(userId));
  final notifier = ref.read(userFormNotifier(userId).notifier);
  return notifier.loadedUser;
});

final userFormNotifier =
    AsyncNotifierProvider.family<UserFormNotifier, void, int?>(
      () => UserFormNotifier(),
    );
