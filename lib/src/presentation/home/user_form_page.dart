import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';
import '../providers/user_form_notifier.dart';
import '../widgets/add_address_dialog.dart';
import '../widgets/input_decorations.dart';

/// Página con el formulario para crear/editar un usuario.
class UserFormPage extends ConsumerStatefulWidget {
  final int? userId;

  const UserFormPage({super.key, this.userId});

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure the notifier instance is created so `build` runs and data loads
      // when editing. Reading the notifier (not the AsyncValue) forces
      // initialization in initState.
      ref.read(userFormNotifier(widget.userId).notifier);
    });
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
    showDialog(
      context: context,
      builder: (_) => AddAddressDialog(
        onAdd: (a) =>
            ref.read(userFormNotifier(widget.userId).notifier).addAddress(a),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona fecha de nacimiento')),
      );
      return;
    }
    final controller = ref.read(userFormNotifier(widget.userId).notifier);
    await controller.onSave(
      firstName: _firstNameCtrl.text,
      lastName: _lastNameCtrl.text,
      birthDate: _birthDate,
    );

    final state = ref.read(userFormNotifier(widget.userId));
    state.when(
      data: (_) {
        Navigator.of(context).pop(true);
      },
      loading: () => null,
      error: (e, st) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to loaded user changes. Must be called inside build.
    ref.listen<User?>(userFormLoadedUserNotifier(widget.userId), (prev, next) {
      if (next != null && mounted) {
        setState(() {
          _firstNameCtrl.text = next.firstName;
          _lastNameCtrl.text = next.lastName;
          _birthDate = next.birthDate;
        });
      }
    });
    final asyncState = ref.watch(userFormNotifier(widget.userId));
    final addresses = ref.watch(userFormAddressesNotifierFamily(widget.userId));

    InputDecoration inputDecoration(String label) =>
        appInputDecoration(context, label);

    final loaded = ref.read(userFormLoadedUserNotifier(widget.userId));
    if (loaded != null) {
      _firstNameCtrl.text = loaded.firstName;
      _lastNameCtrl.text = loaded.lastName;
      _birthDate = loaded.birthDate;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId == null ? 'Crear usuario' : 'Editar usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.transparent,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/app_icon.png'),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _firstNameCtrl,
                            decoration: inputDecoration('Nombre'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Ingresa el nombre'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _lastNameCtrl,
                            decoration: inputDecoration('Apellido'),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Ingresa el apellido'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _birthDate == null
                              ? 'Fecha de nacimiento no seleccionada'
                              : '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}',
                        ),
                      ),
                      TextButton(
                        onPressed: _pickBirthDate,
                        child: const Text('Seleccionar fecha'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Direcciones',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: _addAddress,
                        icon: const Icon(Icons.add_location_alt_outlined),
                        label: const Text('Agregar'),
                      ),
                    ],
                  ),
                  if (addresses.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No hay direcciones registradas'),
                    )
                  else
                    ...addresses.map(
                      (a) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${a.country} · ${a.department} · ${a.municipality}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: asyncWhenNotLoading(asyncState, _submit),
                    child: asyncState.isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.userId == null ? 'Crear' : 'Guardar'),
                  ),
                ],
              ),
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
