import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'auth_user_usecase_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/auth/domain/auth_user_usecase.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';
import 'package:bjj_flow/features/auth/data/repositories/auth_user_repository.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_email_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_not_found_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_password_exeption.dart';

@GenerateMocks([AuthUserRepository])
void main() {
  late AuthUserUseCase authUserUsecase;
  late MockAuthUserRepository mockAuthUserRepository;

  setUp(() {
    mockAuthUserRepository = MockAuthUserRepository();
    authUserUsecase =
        AuthUserUseCase(authUserRepository: mockAuthUserRepository);
  });

  final authUserModel = AuthUserModel(
    userType: 'Student',
    username: 'test_user',
    fullName: 'Test User',
    gender: 'Male',
    birthDate: DateTime(2000, 1, 1),
    phone: '123456789',
    email: 'test@example.com',
    cpf: '123.456.789-00',
    addressId: 'address1',
    graduationId: 'grad1',
    projectId: 'proj1',
    paymentId: 'pay1',
    registrationDate: DateTime.now(),
    updateDate: DateTime.now(),
  );

  test(
      'Deve retornar Result.success com AuthUserModel quando signUp for bem-sucedido',
      () async {
    when(mockAuthUserRepository.signUp(
            email: 'test@example.com', password: 'password123@'))
        .thenAnswer((_) async => Result.success(authUserModel));

    final result =
        await authUserUsecase.call('test@example.com', 'password123@');

    expect(result.isSuccess, true);
    expect(result.data, authUserModel);
    verify(mockAuthUserRepository.signUp(
            email: 'test@example.com', password: 'password123@'))
        .called(1);
  });

  test('Não deve chamar repositório para email inválido', () async {
    expect(
      () => authUserUsecase.call('invalid_email', 'password123@'),
      throwsA(isA<InvalidEmailExeption>()),
    );

    verifyNever(mockAuthUserRepository.signUp(
        email: anyNamed('email'), password: anyNamed('password')));
  });

  test('Não deve chamar repositório para senha inválida', () async {
    expect(
      () => authUserUsecase.call('test@example.com', 'short'),
      throwsA(isA<InvalidPasswordExeption>()),
    );

    verifyNever(mockAuthUserRepository.signUp(
        email: anyNamed('email'), password: anyNamed('password')));
  });

  test('Deve propagar UserNotFoundExeption quando o repositório lançar exceção',
      () async {
    when(mockAuthUserRepository.signUp(
            email: 'notfound@example.com', password: 'password123@'))
        .thenThrow(UserNotFoundExeptions());

    expect(
      () => authUserUsecase.call('notfound@example.com', 'password123@'),
      throwsA(isA<UserNotFoundExeptions>()),
    );
    verify(mockAuthUserRepository.signUp(
            email: 'notfound@example.com', password: 'password123@'))
        .called(1);
  });

  test('Deve propagar ServerException quando o repositório lançar exceção',
      () async {
    when(mockAuthUserRepository.signUp(
            email: 'test@example.com', password: 'password123@'))
        .thenThrow(ServerException());

    expect(
      () => authUserUsecase.call('test@example.com', 'password123@'),
      throwsA(isA<ServerException>()),
    );
    verify(mockAuthUserRepository.signUp(
            email: 'test@example.com', password: 'password123@'))
        .called(1);
  });

  test('Deve lançar exceção genérica para erros inesperados', () async {
    when(mockAuthUserRepository.signUp(
            email: 'test@example.com', password: 'password123@'))
        .thenThrow(Exception("Erro inesperado"));

    expect(
      () => authUserUsecase.call('test@example.com', 'password123@'),
      throwsA(isA<Exception>()),
    );
    verify(mockAuthUserRepository.signUp(
            email: 'test@example.com', password: 'password123@'))
        .called(1);
  });

  test('Deve lançar InvalidEmailExeption para email nulo', () async {
    expect(
      () => authUserUsecase.call(null, 'password123@'),
      throwsA(isA<InvalidEmailExeption>()),
    );

    verifyNever(mockAuthUserRepository.signUp(
        email: anyNamed('email'), password: anyNamed('password')));
  });

  test('Deve lançar UserIncorrectPasswordExeption para senha nula', () async {
    expect(
      () => authUserUsecase.call('test@example.com', null),
      throwsA(isA<InvalidPasswordExeption>()),
    );

    verifyNever(mockAuthUserRepository.signUp(
        email: anyNamed('email'), password: anyNamed('password')));
  });
}
