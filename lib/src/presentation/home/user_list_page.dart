import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../presentation/providers/user_list_provider.dart';
import 'user_form_page.dart';

/// Página que muestra la lista de usuarios.
class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final repo = ref.read(userRepositoryProvider);
      final useCase = GetAllUsersUseCase(repo);
      final notifier = ref.read(userListProvider.notifier);
      notifier.setUseCase(useCase);
      notifier.load();
    });
  }

  Future<void> _deleteUser(int id) async {
    final repo = ref.read(userRepositoryProvider);
    await repo.deleteUser(id);
    await ref.read(userListProvider.notifier).load();
  }

  void _editUser(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const UserFormPage()));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListProvider);

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
                title: Text('${u.firstName} ${u.lastName}'),
                subtitle: Text('${u.birthDate.toLocal()}'.split(' ')[0]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editUser(context),
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
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const UserFormPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
