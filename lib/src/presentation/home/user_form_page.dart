import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/models/address.dart';
import '../../data/models/user.dart';
import '../../domain/usecases/create_user_usecase.dart';
import '../providers/user_form_provider.dart';

/// Página con el formulario para crear/editar un usuario.
///
/// Contendrá campos para nombre, apellido, fecha de nacimiento y
/// una lista para agregar múltiples direcciones.
class UserFormPage extends ConsumerStatefulWidget {
  const UserFormPage({super.key});

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  DateTime? _birthDate;

  final List<Address> _addresses = [];

  @override
  void initState() {
    super.initState();
    final repo = ref.read(userRepositoryProvider);
    final useCase = CreateUserUseCase(repo);
    final provider = ref.read(userFormProvider.notifier);
    provider.setUseCase(useCase);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;

    DateTime subtractMonths(DateTime date, int months) {
      int year = date.year;
      int month = date.month - months;
      while (month <= 0) {
        month += 12;
        year -= 1;
      }

      final lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
      final day = date.day > lastDayOfTargetMonth
          ? lastDayOfTargetMonth
          : date.day;

      return DateTime(
        year,
        month,
        day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    }

    final nineMonthsAgo = subtractMonths(now, 9);

    if (picked.isAfter(nineMonthsAgo)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La fecha debe ser al menos 9 meses anterior a hoy'),
          ),
        );
      }
      return;
    }

    setState(() => _birthDate = picked);
  }

  void _addAddress() {
    final countryCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    final muniCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar dirección'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: countryCtrl,
              decoration: const InputDecoration(labelText: 'País'),
            ),
            TextField(
              controller: deptCtrl,
              decoration: const InputDecoration(labelText: 'Departamento'),
            ),
            TextField(
              controller: muniCtrl,
              decoration: const InputDecoration(labelText: 'Municipio'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _addresses.add(
                  Address.create(
                    country: countryCtrl.text,
                    department: deptCtrl.text,
                    municipality: muniCtrl.text,
                  ),
                );
              });
              Navigator.of(context).pop();
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha de nacimiento')),
      );
      return;
    }

    final user = User.create(
      firstName: _firstNameCtrl.text,
      lastName: _lastNameCtrl.text,
      birthDate: _birthDate!,
    );
    user.addresses.addAll(_addresses);

    final controller = ref.read(userFormProvider.notifier);
    await controller.submit(user);

    final state = ref.read(userFormProvider);
    state.when(
      data: (_) {
        Navigator.of(context).pop();
      },
      loading: () => null,
      error: (e, st) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(userFormProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _firstNameCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameCtrl,
                  decoration: const InputDecoration(labelText: 'Apellido'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
                const SizedBox(height: 8),
                ListTile(
                  subtitle: _birthDate != null
                      ? Text('Fecha de nacimiento')
                      : null,
                  title: Text(
                    _birthDate == null
                        ? 'Fecha de nacimiento'
                        : '${_birthDate!.toLocal()}'.split(' ')[0],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _pickBirthDate,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Direcciones',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._addresses.map(
                  (a) => ListTile(
                    title: Text(
                      '${a.country} - ${a.department} - ${a.municipality}',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _addAddress,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar dirección'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: asyncWhenNotLoading(asyncState, _submit),
                  child: asyncState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

VoidCallback? Function(AsyncValue<void>, VoidCallback) asyncWhenNotLoading =
    (state, cb) {
      return state.isLoading ? null : cb;
    };
