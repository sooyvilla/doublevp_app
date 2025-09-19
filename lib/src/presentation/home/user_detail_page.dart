import 'package:flutter/material.dart';

/// Página de detalle de un usuario. Muestra los datos y direcciones.
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle usuario'),
      ),
      body: const Center(
        child: Text('Detalle (placeholder)'),
      ),
    );
  }
}
