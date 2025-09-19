import 'dart:io';

import 'package:doublevp_app/src/data/repositories/hive_user_repository.dart';
import 'package:doublevp_app/src/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('hive_test');
    Hive.init(tempDir.path);
  });

  tearDownAll(() {
    try {
      Hive.close();
      tempDir.deleteSync(recursive: true);
    } catch (_) {}
  });

  test('crear y obtener usuario', () async {
    final repo = HiveUserRepository();
    final u = User.create(firstName: 'Luis', lastName: 'Gomez', birthDate: DateTime(1985, 3, 1));

    final saved = await repo.createUser(u);
    expect(saved.id, greaterThan(0));

    final fetched = await repo.getUserById(saved.id);
    expect(fetched, isNotNull);
    expect(fetched!.firstName, 'Luis');
  });

  test('actualizar usuario', () async {
    final repo = HiveUserRepository();
    final u = User.create(firstName: 'Marta', lastName: 'Diaz', birthDate: DateTime(1992, 7, 7));
    final saved = await repo.createUser(u);

    saved.firstName = 'Marta Actualizada';
    final updated = await repo.updateUser(saved);
    expect(updated.firstName, 'Marta Actualizada');
  });
}
