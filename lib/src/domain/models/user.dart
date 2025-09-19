import 'package:isar/isar.dart';

import 'address.dart';

part 'user.g.dart';

/// Modelo User almacenado en Isar.
@Collection()
class User {
  Id id = Isar.autoIncrement;

  late String firstName;
  late String lastName;
  late DateTime birthDate;

  final addresses = IsarLinks<Address>();

  User();

  User.create({required this.firstName, required this.lastName, required this.birthDate});
}
