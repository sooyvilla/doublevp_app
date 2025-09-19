import 'package:doublevp_app/src/domain/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;

  setUp(() {
    mockRepo = MockUserRepository();
  });

  test('mock example getAllUsers returns empty list', () async {
    when(() => mockRepo.getAllUsers()).thenAnswer((_) async => []);

    final users = await mockRepo.getAllUsers();

    expect(users, isEmpty);
  });
}
