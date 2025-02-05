import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'auth_user_repository_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';
import 'package:bjj_flow/features/auth/data/repositories/auth_user_repository_impl.dart';
import 'package:bjj_flow/features/auth/data/services/auth_user_client_service_impl.dart';

@GenerateMocks([AuthUserClientServiceImpl])
void main() {
  late AuthUserRepositoryImpl authUserRepositoryImpl;
  late MockAuthUserClientServiceImpl mockAuthUserClientServiceImpl;

  setUp(() {
    mockAuthUserClientServiceImpl = MockAuthUserClientServiceImpl();
    authUserRepositoryImpl = AuthUserRepositoryImpl(
        authUserClientService: mockAuthUserClientServiceImpl);
  });

  final authUserData = {
    "email": 'test@example.com',
    "password": 'Pa@ssword123',
  };

  test("Deve retornar sucesso ao autenticar com dados válidos", () async {
    when(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'Pa@ssword123',
    )).thenAnswer((_) async => Result.success(authUserData));

    final result = await authUserRepositoryImpl.signUp(
      email: 'test@example.com',
      password: 'Pa@ssword123',
    );

    expect(result.isSuccess, isTrue);
    expect(result.data, isA<AuthUserModel>());
    expect(result.data?.email, equals('test@example.com'));
    verify(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'Pa@ssword123',
    )).called(1);
  });

  test('Deve retornar erro quando o serviço de autenticação falhar', () async {
    when(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'password123@',
    )).thenThrow(ServerException());

    await expectLater(
      () => authUserRepositoryImpl.signUp(
        email: 'test@example.com',
        password: 'password123@',
      ),
      throwsA(isA<ServerException>()),
    );

    verify(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'password123@',
    )).called(1);
  });

  test('Deve chamar o serviço de autenticação apenas uma vez', () async {
    when(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'Pa@ssword123',
    )).thenAnswer((_) async => Result.success(authUserData));

    await authUserRepositoryImpl.signUp(
      email: 'test@example.com',
      password: 'Pa@ssword123',
    );

    verify(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'Pa@ssword123',
    )).called(1);
  });
}
