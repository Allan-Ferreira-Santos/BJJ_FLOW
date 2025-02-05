import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'auth_user_view_model_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/auth/domain/auth_user_usecase.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_email_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_not_found_exeption.dart';
import 'package:bjj_flow/features/auth/presentation/view_models/auth_user_view_model.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_incorrect_password_exeption.dart';

@GenerateMocks([AuthUserUseCase])
void main() {
  late MockAuthUserUseCase mockAuthUserUseCase;
  late AuthUserViewModel authUserViewModel;

  setUp(() {
    mockAuthUserUseCase = MockAuthUserUseCase();
    authUserViewModel = AuthUserViewModel(authUserUsecase: mockAuthUserUseCase);
  });

  final authUserModel = AuthUserModel(
    email: 'teste@example.com',
    password: 'password@123',
    
  );

  Matcher resultMatcher(Result<AuthUserModel> expectedResult) {
    return isA<Result<AuthUserModel>>()
        .having(
            (result) => result.isSuccess, 'isSuccess', expectedResult.isSuccess)
        .having(
            (result) => result.isFailure, 'isFailure', expectedResult.isFailure)
        .having(
            (result) => result.isLoading, 'isLoading', expectedResult.isLoading)
        .having((result) => result.data, 'data', expectedResult.data)
        .having((result) => result.error, 'error', expectedResult.error);
  }

  group('AuthUserViewModel', () {
    test('Deve emitir loading e success quando o signUp for bem-sucedido',
        () async {
      when(mockAuthUserUseCase.call('test@example.com', 'password123'))
          .thenAnswer((_) async => Result.success(authUserModel));

      expectLater(
        authUserViewModel.authUserStream,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(Result.success(authUserModel)),
        ]),
      );

      await authUserViewModel.signUp(
          email: 'test@example.com', password: 'password123');
    });

    test(
        'Deve emitir loading e failure quando o signUp falhar com InvalidEmailExeption',
        () async {
      when(mockAuthUserUseCase.call('invalid_email', 'password123')).thenThrow(
          InvalidEmailExeption(message: 'The email provided is invalid.'));

      expectLater(
        authUserViewModel.authUserStream,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(Result.failure('The email provided is invalid.')),
        ]),
      );

      await authUserViewModel.signUp(
          email: 'invalid_email', password: 'password123');
    });

    test(
        'Deve emitir loading e failure quando o signUp falhar com UserNotFoundExeption',
        () async {
      when(mockAuthUserUseCase.call('notfound@example.com', 'password123'))
          .thenThrow(UserNotFoundExeptions());

      expectLater(
        authUserViewModel.authUserStream,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(Result.failure('User not found.')),
        ]),
      );

      await authUserViewModel.signUp(
          email: 'notfound@example.com', password: 'password123');
    });

    test(
        'Deve emitir loading e failure quando o signUp falhar com UserIncorrectPasswordExeption',
        () async {
      when(mockAuthUserUseCase.call('test@example.com', 'wrongpassword'))
          .thenThrow(
              UserIncorrectPasswordExeption(message: 'password is incorrect'));

      expectLater(
        authUserViewModel.authUserStream,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(Result.failure('password is incorrect')),
        ]),
      );

      await authUserViewModel.signUp(
          email: 'test@example.com', password: 'wrongpassword');
    });

    test('Deve emitir loading e failure ao lançar exceção inesperada',
        () async {
      when(mockAuthUserUseCase.call('any_email', 'password'))
          .thenThrow(Exception("Something went wrong"));

      expectLater(
          authUserViewModel.authUserStream,
          emitsInOrder([
            resultMatcher(Result.loading()),
            resultMatcher(Result.failure(
                "An unexpected error occurred. Please try again.")),
          ]));

      await authUserViewModel.signUp(email: 'any_email', password: 'password');
    });

    test('Deve alterar visibilidade da senha corretamente', () {
      expect(authUserViewModel.isVisiblePassword, false);
      authUserViewModel.togglePasswordVisibility();
      expect(authUserViewModel.isVisiblePassword, true);
      authUserViewModel.togglePasswordVisibility();
      expect(authUserViewModel.isVisiblePassword, false);
    });

    test('Deve fechar o StreamController quando dispose for chamado', () {
      authUserViewModel.dispose();
      expect(authUserViewModel.authUserController.isClosed, true);
    });

    test('Não deve emitir eventos após dispose', () async {
      authUserViewModel.dispose();

      expect(
        () => authUserViewModel.authUserController.add(Result.loading()),
        throwsA(isA<StateError>()),
      );
    });
  });
}
