import 'package:doublevp_app/src/domain/models/address.dart';
import 'package:doublevp_app/src/domain/models/user.dart';

/// DTO / Mapper para convertir entre dominio (`User`/`Address`) y `Map`.
class UserMapper {
  UserMapper._();

  static Map<String, dynamic> toMap(User u) {
    return {
      'firstName': u.firstName,
      'lastName': u.lastName,
      'birthDate': u.birthDate.toIso8601String(),
      'addresses': u.plainAddresses.map((a) => _addressToMap(a)).toList(),
    };
  }

  static Map<String, dynamic> _addressToMap(Address a) {
    return {
      'country': a.country,
      'department': a.department,
      'municipality': a.municipality,
    };
  }

  static User fromMap(int id, Map<String, dynamic> m) {
    final u = User()
      ..id = id
      ..firstName = m['firstName'] as String? ?? ''
      ..lastName = m['lastName'] as String? ?? ''
      ..birthDate =
          DateTime.tryParse(m['birthDate'] as String? ?? '') ?? DateTime.now();

    final list =
        (m['addresses'] as List<dynamic>?)
            ?.map(
              (e) => Address()
                ..country = (e as Map)['country'] as String? ?? ''
                ..department = e['department'] as String? ?? ''
                ..municipality = e['municipality'] as String? ?? '',
            )
            .toList() ??
        [];
    u.plainAddresses = list;
    return u;
  }
}
