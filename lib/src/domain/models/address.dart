/// Modelo Address para guardar las direcciones
class Address {
  String country = '';
  String department = '';
  String municipality = '';

  Address();

  Address.create({
    required this.country,
    required this.department,
    required this.municipality,
  });
}
