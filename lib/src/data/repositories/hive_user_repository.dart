import 'package:doublevp_app/src/domain/models/address.dart';
import 'package:doublevp_app/src/domain/models/user.dart';
import 'package:doublevp_app/src/domain/repositories/user_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveUserRepository implements UserRepository {
  static const String boxName = 'users_box';

  Box<Map>? _box;

  Future<Box<Map>> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;
    _box = await Hive.openBox<Map>(boxName);
    return _box!;
  }

  Map<String, dynamic> _userToMap(User u) {
    return {
      'firstName': u.firstName,
      'lastName': u.lastName,
      'birthDate': u.birthDate.toIso8601String(),
      'addresses': u.plainAddresses.map((a) => _addressToMap(a)).toList(),
    };
  }

  Map<String, dynamic> _addressToMap(Address a) {
    return {
      'country': a.country,
      'department': a.department,
      'municipality': a.municipality,
    };
  }

  User _mapToUser(int id, Map m) {
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

  int _nextId(Iterable<dynamic> keys) {
    final ints = keys.cast<int>();
    if (ints.isEmpty) return 1;
    return ints.reduce((a, b) => a > b ? a : b) + 1;
  }

  @override
  Future<User> createUser(User user) async {
    final box = await _openBox();
    final id = _nextId(box.keys);
    final map = _userToMap(user..id = id);
    await box.put(id, map);
    return _mapToUser(id, Map<String, dynamic>.from(map));
  }

  @override
  Future<void> deleteUser(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<User>> getAllUsers() async {
    final box = await _openBox();
    return box.keys.cast<int>().map((k) {
      final m = Map<String, dynamic>.from(box.get(k) ?? {});
      return _mapToUser(k, m);
    }).toList();
  }

  @override
  Future<User?> getUserById(int id) async {
    final box = await _openBox();
    final m = box.get(id);
    if (m == null) return null;
    return _mapToUser(id, Map<String, dynamic>.from(m));
  }

  @override
  Future<User> updateUser(User user) async {
    final box = await _openBox();
    var id = user.id;
    if (id <= 0) {
      id = _nextId(box.keys);
      user.id = id;
    }
    final map = _userToMap(user);
    await box.put(id, map);
    return _mapToUser(id, map);
  }
}
