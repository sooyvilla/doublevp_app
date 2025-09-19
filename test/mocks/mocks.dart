import 'package:doublevp_app/src/domain/usecases/create_user_usecase.dart';
import 'package:doublevp_app/src/domain/usecases/update_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateUserUseCase extends Mock implements CreateUserUseCase {}

class MockUpdateUserUseCase extends Mock implements UpdateUserUseCase {}
