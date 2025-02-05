import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'register_user_view_model_test.mocks.dart';
import 'package:bjj_flow/features/register_user/domain/register_user_usecase.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';
import 'package:bjj_flow/features/register_user/presentation/view_models/register_user_view_model.dart';

@GenerateMocks([RegisterUserUseCase])
void main() {
  late RegisterUserViewModel registerUserViewModel;
  late MockRegisterUserUseCase mockRegisterUserUsecase;

  setUp(() {
    mockRegisterUserUsecase = MockRegisterUserUseCase();
    registerUserViewModel =
        RegisterUserViewModel(registerUserUsecase: mockRegisterUserUsecase);
  });

  final registerUser = RegisterUserModel(
      userType: "1",
      username: "name",
      fullName: "name full",
      gender: "gender",
      birthDate: DateTime.now(),
      phone: "phone",
      email: "email",
      cpf: "cpf",
      addressId: "addressId",
      graduationId: "graduationId",
      projectId: "projectId",
      paymentId: "paymentId",
      registrationDate: DateTime.now(),
      updateDate: DateTime.now());

  Matcher resultMatcher(Result expectedResult) {
    return isA<Result>()
        .having(
            (result) => result.isSuccess, 'isSuccess', expectedResult.isSuccess)
        .having(
            (result) => result.isFailure, 'isFailure', expectedResult.isFailure)
        .having(
            (result) => result.isLoading, 'isLoading', expectedResult.isLoading)
        .having((result) => result.data, 'data', expectedResult.data)
        .having((result) => result.error, 'error', expectedResult.error);
  }

  test("Deve emitir estados de carregamento e sucesso ao registrar um usuário",
      () async {
    when(mockRegisterUserUsecase.call(registerUser))
        .thenAnswer((_) async => Result.success());

    expectLater(
      registerUserViewModel.registerUserStream,
      emitsInOrder([
        resultMatcher(Result.loading()),
        resultMatcher(Result.success()),
      ]),
    );

    await registerUserViewModel.registerUser(registerUser);
  });

  test(
      "Deve emitir estados de carregamento e falha ao registrar um usuário com erro",
      () async {
    when(mockRegisterUserUsecase.call(registerUser))
        .thenAnswer((_) async => Result.failure("Erro ao registrar"));

    expectLater(
      registerUserViewModel.registerUserStream,
      emitsInOrder([
        resultMatcher(Result.loading()),
        resultMatcher(Result.failure("Erro ao registrar")),
      ]),
    );

    await registerUserViewModel.registerUser(registerUser);
  });

  test("Deve emitir estados de carregamento e falha ao lançar exceção",
      () async {
    when(mockRegisterUserUsecase.call(registerUser))
        .thenThrow(Exception("Erro inesperado"));

    expectLater(
      registerUserViewModel.registerUserStream,
      emitsInOrder([
        resultMatcher(Result.loading()),
        resultMatcher(Result.failure("Exception: Erro inesperado")),
      ]),
    );

    await registerUserViewModel.registerUser(registerUser);
  });

  test("Deve fechar o StreamController quando dispose for chamado", () async {
    registerUserViewModel.dispose();

    expect(registerUserViewModel.controllerRegisterUser.isClosed, true);
  });
}
