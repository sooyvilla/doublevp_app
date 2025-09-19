import 'package:flutter/material.dart';

/// Página con el formulario para crear/editar un usuario.
///
/// Contendrá campos para nombre, apellido, fecha de nacimiento y
/// una lista para agregar múltiples direcciones.
class UserFormPage extends StatelessWidget {
  const UserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear usuario')),
      body: const Center(child: Text('Formulario (placeholder)')),
    );
  }
}
