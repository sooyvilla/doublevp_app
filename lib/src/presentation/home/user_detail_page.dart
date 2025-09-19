import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_detail_notifier.dart';
import '../widgets/initials_avatar.dart';

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
          String formatDate(DateTime d) {
            final dt = d.toLocal();
            final day = dt.day.toString().padLeft(2, '0');
            final month = dt.month.toString().padLeft(2, '0');
            final year = dt.year.toString();
            return '$day/$month/$year';
          }

          String initials() {
            final fn = u.firstName.trim();
            final ln = u.lastName.trim();
            final a = fn.isNotEmpty ? fn[0] : '';
            final b = ln.isNotEmpty ? ln[0] : '';
            return (a + b).toUpperCase();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    InitialsAvatar(
                      firstName: u.firstName,
                      lastName: u.lastName,
                      heroTag: 'user-${u.id}-avatar',
                      radius: 34,
                      child: Text(
                        initials(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${u.firstName} ${u.lastName}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.cake, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                formatDate(u.birthDate),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Direcciones',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        if (u.plainAddresses.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No hay direcciones registradas'),
                          )
                        else
                          ...u.plainAddresses.map(
                            (a) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${a.country} · ${a.department} · ${a.municipality}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
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
