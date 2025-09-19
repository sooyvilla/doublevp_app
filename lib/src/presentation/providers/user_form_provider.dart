import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user.dart';
import '../../domain/usecases/create_user_usecase.dart';

final userFormProvider = AsyncNotifierProvider<UserFormProvider, void>(
  () => UserFormProvider(),
);

class UserFormProvider extends AsyncNotifier<void> {
  late CreateUserUseCase _useCase;

  @override
  Future<void> build() async {}

  void setUseCase(CreateUserUseCase useCase) {
    _useCase = useCase;
  }

  Future<void> submit(User user) async {
    state = const AsyncValue.loading();
    try {
      await _useCase.call(user);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
