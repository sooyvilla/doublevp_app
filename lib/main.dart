import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/theme.dart';
import 'src/presentation/home/user_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoubleVP Test',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const UserListPage(),
    );
  }
}
