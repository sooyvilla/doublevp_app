import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/user.dart';
import '../../domain/usecases/get_all_users_usecase.dart';

final getAllUsersUseCaseNotifier = Provider<GetAllUsersUseCase>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return GetAllUsersUseCase(repo);
});

final userListNotifier = AsyncNotifierProvider<UserListNotifier, List<User>>(
  () => UserListNotifier(),
);

class UserListNotifier extends AsyncNotifier<List<User>> {
  @override
  Future<List<User>> build() async {
    final useCase = ref.read(getAllUsersUseCaseNotifier);
    state = const AsyncValue.loading();
    try {
      final list = await useCase.call();
      state = AsyncValue.data(list);
      return list;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> refresh() async {
    final useCase = ref.read(getAllUsersUseCaseNotifier);
    state = const AsyncValue.loading();
    try {
      final list = await useCase.call();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
