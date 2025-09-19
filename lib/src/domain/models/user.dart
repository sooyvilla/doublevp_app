import 'address.dart';

/// Modelo User del dominio (sin dependencia a Isar).
class User {
  int id = 0;

  late String firstName;
  late String lastName;
  late DateTime birthDate;

  List<Address> plainAddresses = [];

  User();

  User.create({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });
}
