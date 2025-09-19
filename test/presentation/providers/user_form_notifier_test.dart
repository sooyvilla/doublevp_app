import 'package:doublevp_app/src/domain/models/user.dart';
import 'package:doublevp_app/src/presentation/providers/user_form_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(User());
  });

  test('guardar usuario nuevo exitoso', () async {
    final mockCreate = MockCreateUserUseCase();
    when(() => mockCreate.call(any())).thenAnswer((_) async => User());

    final container = ProviderContainer(overrides: [
      createUserUseCaseNotifier.overrideWithValue(mockCreate),
    ]);

    addTearDown(container.dispose);

    final notifier = container.read(userFormNotifier(null).notifier);

    await notifier.onSave(
      firstName: 'Paco',
      lastName: 'Perez',
      birthDate: DateTime(2000, 1, 1),
    );

    final state = container.read(userFormNotifier(null));
    expect(state.isLoading, false);
    expect(state.hasError, false);
    verify(() => mockCreate.call(any())).called(1);
  });

  test('onSave valida y falla si falta nombre', () async {
    final mockCreate = MockCreateUserUseCase();
    final container = ProviderContainer(overrides: [
      createUserUseCaseNotifier.overrideWithValue(mockCreate),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(userFormNotifier(null).notifier);

    await notifier.onSave(
      firstName: '',
      lastName: 'Perez',
      birthDate: DateTime(2000, 1, 1),
    );

  final state = container.read(userFormNotifier(null));
  expect(state.isLoading, false);
  verifyNever(() => mockCreate.call(any()));
  });
}
