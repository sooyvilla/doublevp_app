import 'package:isar/isar.dart';

part 'address.g.dart';

/// Modelo Address almacenado en Isar.
@Collection()
class Address {
  Id id = Isar.autoIncrement;

  late String country;
  late String department;
  late String municipality;

  Address();

  Address.create({required this.country, required this.department, required this.municipality});
}
