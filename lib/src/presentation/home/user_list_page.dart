import 'package:flutter/material.dart';

import 'user_detail_page.dart';
import 'user_form_page.dart';

/// Página que muestra la lista de usuarios.
///
/// Aquí se listarán los usuarios guardados y se podrá navegar
/// a crear un nuevo usuario o ver los detalles.
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Lista de usuarios (placeholder)'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserFormPage()),
              ),
              child: const Text('Crear usuario'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UserDetailPage()),
              ),
              child: const Text('Ver detalle (placeholder)'),
            ),
          ],
        ),
      ),
    );
  }
}
