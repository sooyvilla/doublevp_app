import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../domain/usecases/get_all_users_usecase.dart';

final userListNotifier = AsyncNotifierProvider<UserListNotifier, List<User>>(
  () => UserListNotifier(),
);

class UserListNotifier extends AsyncNotifier<List<User>> {
  late GetAllUsersUseCase _useCase;

  @override
  Future<List<User>> build() async {
    return [];
  }

  void setUseCase(GetAllUsersUseCase useCase) {
    _useCase = useCase;
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final list = await _useCase.call();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
