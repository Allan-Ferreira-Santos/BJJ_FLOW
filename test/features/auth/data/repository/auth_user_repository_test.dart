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
    "userType": 'Student',
    "username": 'test_user',
    "fullName": 'Test User',
    "gender": 'Male',
    "birthDate": DateTime(2000, 1, 1).toIso8601String(),
    "phone": '123456789',
    "email": 'test@example.com',
    "cpf": '123.456.789-00',
    "addressId": 'address1',
    "graduationId": 'grad1',
    "projectId": 'proj1',
    "paymentId": 'pay1',
    "registrationDate": DateTime.now().toIso8601String(),
    "updateDate": DateTime.now().toIso8601String(),
  };

  test("Deve retornar sucesso ao autenticar com dados válidos", () async {
    when(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'pa@ssword123',
    )).thenAnswer((_) async => Result.success(authUserData));

    final result = await authUserRepositoryImpl.signUp(
        email: 'test@example.com', password: 'pa@ssword123');

    expect(result.isSuccess, true);
    expect(result.data, isA<AuthUserModel>());
    expect(result.data?.username, 'test_user');
    verify(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'pa@ssword123',
    )).called(1);
  });

  test('Deve retornar erro quando o serviço de autenticação falhar', () async {
    when(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'password123@',
    )).thenThrow(ServerException());

    final result = authUserRepositoryImpl.signUp(
      email: 'test@example.com',
      password: 'password123@',
    );

    await expectLater(
      result,
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
      password: 'pa@ssword123',
    )).thenAnswer((_) async => Result.success(authUserData));

    await authUserRepositoryImpl.signUp(
        email: 'test@example.com', password: 'pa@ssword123');

    verify(mockAuthUserClientServiceImpl.signUp(
      email: 'test@example.com',
      password: 'pa@ssword123',
    )).called(1);
  });
}
