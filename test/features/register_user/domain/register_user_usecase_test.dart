import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'register_user_usecase_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/register_user/domain/register_user_usecase.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';
import 'package:bjj_flow/features/register_user/data/repositories/register_user_repository.dart';

@GenerateMocks([RegisterUserRepository])
void main() {
  late MockRegisterUserRepository registerUserRepository;
  late RegisterUserUseCase registerUserUseCase;

  setUp(() {
    registerUserRepository = MockRegisterUserRepository();
    registerUserUseCase =
        RegisterUserUseCase(registerUserRepository: registerUserRepository);
  });

  final validUser = RegisterUserModel(
    userType: "1",
    username: "name",
    fullName: "name full",
    gender: "gender",
    birthDate: DateTime(2000, 1, 1),
    phone: "99999999999",
    email: "test@example.com",
    cpf: "12345678900",
    addressId: "addressId",
    graduationId: "graduationId",
    projectId: "projectId",
    paymentId: "paymentId",
    registrationDate: DateTime.now(),
    updateDate: DateTime.now(),
  );

  test("Deve retornar falha se os dados do usuário forem nulos", () async {
    final result = await registerUserUseCase.call(null);

    expect(result.isFailure, true);
    expect(result.error, "Dados do usuário não podem ser nulos");
  });

  test("Deve retornar falha se houver erro de validação nos dados", () async {
    final invalidUser = RegisterUserModel(
        userType: "1",
        username: "",
        fullName: "name full",
        gender: "gender",
        birthDate: DateTime(2000, 1, 1),
        phone: "99999999999",
        email: "test@example.com",
        cpf: "12345678900",
        addressId: "addressId",
        graduationId: "graduationId",
        projectId: "projectId",
        paymentId: "paymentId",
        registrationDate: DateTime.now(),
        updateDate: DateTime.now());

    final result = await registerUserUseCase.call(invalidUser);

    expect(result.isFailure, true);
    expect(result.error, isNotEmpty);
  });

  test("Deve retornar sucesso ao registrar usuário corretamente", () async {
    when(registerUserRepository.registerUser(registerUserModel: validUser))
        .thenAnswer((_) async => Result.success());

    final result = await registerUserUseCase.call(validUser);

    expect(result.isSuccess, true);
  });

  test("Deve retornar falha se o repositório lançar erro", () async {
    when(registerUserRepository.registerUser(registerUserModel: validUser))
        .thenThrow(Exception("Erro ao registrar usuário"));

    expectLater(
      () async => await registerUserUseCase.call(validUser),
      throwsA(isA<Exception>()),
    );
  });
}
