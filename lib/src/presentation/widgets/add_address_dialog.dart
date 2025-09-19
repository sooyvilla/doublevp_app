import 'package:flutter/material.dart';

import '../../domain/models/address.dart';
import 'input_decorations.dart';

typedef AddressCallback = void Function(Address a);

class AddAddressDialog extends StatefulWidget {
  final AddressCallback onAdd;

  const AddAddressDialog({super.key, required this.onAdd});

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _country = TextEditingController();
  final _department = TextEditingController();
  final _municipality = TextEditingController();

  @override
  void dispose() {
    _country.dispose();
    _department.dispose();
    _municipality.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final a = Address.create(
      country: _country.text.trim(),
      department: _department.text.trim(),
      municipality: _municipality.text.trim(),
    );
    widget.onAdd(a);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Agregar dirección',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _country,
                    autofocus: true,
                    decoration: appInputDecoration(
                      context,
                      'País',
                      icon: Icons.flag,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Ingresa país' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _department,
                    decoration: appInputDecoration(
                      context,
                      'Departamento',
                      icon: Icons.map,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingresa departamento'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _municipality,
                    decoration: appInputDecoration(
                      context,
                      'Municipio',
                      icon: Icons.location_city,
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Ingresa municipio'
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
