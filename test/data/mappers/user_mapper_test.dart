import 'package:doublevp_app/src/data/mappers/user_mapper.dart';
import 'package:doublevp_app/src/domain/models/address.dart';
import 'package:doublevp_app/src/domain/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mapear usuario a map y volver a usuario', () {
    final user = User.create(
      firstName: 'Ana',
      lastName: 'Lopez',
      birthDate: DateTime(1990, 5, 20),
    );
    user.plainAddresses = [
      Address.create(
        country: 'Colombia',
        department: 'Cundinamarca',
        municipality: 'Bogotá',
      ),
    ];

    final map = UserMapper.toMap(user);
    final restored = UserMapper.fromMap(10, map);

    expect(restored.id, 10);
    expect(restored.firstName, 'Ana');
    expect(restored.lastName, 'Lopez');
    expect(restored.birthDate.year, 1990);
    expect(restored.plainAddresses, isNotEmpty);
    expect(restored.plainAddresses.first.country, 'Colombia');
  });
}
