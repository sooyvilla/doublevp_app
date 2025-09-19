import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../domain/models/user.dart';

final userDetailNotifier = FutureProvider.family<User?, int>((ref, id) async {
  final repo = ref.read(userRepositoryProvider);
  return await repo.getUserById(id);
});
