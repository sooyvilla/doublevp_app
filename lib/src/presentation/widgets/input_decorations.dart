import 'package:flutter/material.dart';

InputDecoration appInputDecoration(
  BuildContext context,
  String label, {
  IconData? icon,
}) {
  final color = Theme.of(context).colorScheme;
  return InputDecoration(
    labelText: label,
    prefixIcon: icon != null ? Icon(icon, size: 20) : null,
    filled: true,
    fillColor: color.surfaceContainerHighest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );
}
