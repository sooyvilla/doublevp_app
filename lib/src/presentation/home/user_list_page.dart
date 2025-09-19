import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../providers/user_list_notifier.dart';
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
              return ListTile(
                title: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => UserDetailPage(userId: u.id),
                    ),
                  ),
                  child: Text('${u.firstName} ${u.lastName}'),
                ),
                subtitle: Text('${u.birthDate.toLocal()}'.split(' ')[0]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UserFormPage(userId: u.id),
                          ),
                        );
                        if (result == true) {
                          await ref.read(userListNotifier.notifier).refresh();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteUser(u.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addUser',
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const UserFormPage()));
          if (result == true)
            await ref.read(userListNotifier.notifier).refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
