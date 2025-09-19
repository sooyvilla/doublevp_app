import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doublevp_app/src/presentation/home/user_form_page.dart';
import 'package:doublevp_app/src/core/providers.dart';
import 'package:doublevp_app/src/domain/models/user.dart';
import 'package:doublevp_app/src/domain/repositories/user_repository.dart';

class _FakeRepo implements UserRepository {
  @override
  Future<User?> getUserById(int id) async => null;

  @override
  Future<User> createUser(User user) async => user..id = 1;

  @override
  Future<void> deleteUser(int id) async {}

  @override
  Future<List<User>> getAllUsers() async => [];

  @override
  Future<User> updateUser(User user) async => user;
}

void main() {
  testWidgets('UserFormPage muestra campos y botones', (tester) async {
    await tester.pumpWidget(
      ProviderScope(overrides: [userRepositoryProvider.overrideWithValue(_FakeRepo())], child: const MaterialApp(home: UserFormPage())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Apellido'), findsOneWidget);
  expect(find.text('Agregar'), findsOneWidget);
  expect(find.text('Crear'), findsOneWidget);
  });
}
