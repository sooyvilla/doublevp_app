import 'package:flutter/material.dart';

/// Avatar que muestra iniciales a partir de nombre y apellido.
/// Si se proporciona [heroTag], envuelve el avatar en un [Hero].
class InitialsAvatar extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String? heroTag;
  final double radius;
  final Color? backgroundColor;
  final Widget? child;

  const InitialsAvatar({
    super.key,
    required this.firstName,
    required this.lastName,
    this.heroTag,
    this.radius = 20,
    this.backgroundColor,
    this.child,
  });

  String _initials() {
    final a = firstName.trim().isNotEmpty ? firstName.trim()[0] : '';
    final b = lastName.trim().isNotEmpty ? lastName.trim()[0] : '';
    return (a + b).toUpperCase();
  }

  Widget _buildAvatar(BuildContext context) {
    if (child != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.primary,
        child: child,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      child: Text(
        _initials(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _buildAvatar(context);
    if (heroTag == null) return avatar;
    return Hero(tag: heroTag!, child: avatar);
  }
}
