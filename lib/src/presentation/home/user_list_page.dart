import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../providers/user_list_notifier.dart';
import '../widgets/initials_avatar.dart';
import 'user_detail_page.dart';
import 'user_form_page.dart';

/// Página que muestra la lista de usuarios.
class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  Future<void> _deleteUser(int id) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.deleteUser(id);
    await ref.read(userListNotifier.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListNotifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: state.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('No hay usuarios'));
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final u = list[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UserDetailPage(userId: u.id),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      child: Row(
                        children: [
                          InitialsAvatar(
                            firstName: u.firstName,
                            lastName: u.lastName,
                            heroTag: 'user-${u.id}-avatar',
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${u.firstName} ${u.lastName}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${u.birthDate.toLocal()}'.split(' ')[0],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => UserFormPage(userId: u.id),
                                ),
                              );
                              if (result == true) {
                                await ref
                                    .read(userListNotifier.notifier)
                                    .refresh();
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteUser(u.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-add-user',
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const UserFormPage()));
          if (result == true) {
            await ref.read(userListNotifier.notifier).refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
