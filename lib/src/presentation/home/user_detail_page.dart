import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_detail_notifier.dart';

/// Página que muestra detalles de un usuario y sus direcciones.
class UserDetailPage extends ConsumerWidget {
  final int userId;

  const UserDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userDetailNotifier(userId));
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del usuario')),
      body: asyncUser.when(
        data: (u) {
          if (u == null) {
            return const Center(child: Text('Usuario no encontrado'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${u.firstName} ${u.lastName}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('Nacimiento: ${u.birthDate.toLocal()}'.split(' ')[0]),
                const SizedBox(height: 12),
                const Text(
                  'Direcciones',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...u.addresses.toList().map(
                  (a) => ListTile(
                    title: Text(
                      '${a.country} - ${a.department} - ${a.municipality}',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
