import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'register_user_repository_test.mocks.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';
import 'package:bjj_flow/features/register_user/data/services/register_user_client_service.dart';
import 'package:bjj_flow/features/register_user/data/repositories/register_user_repository_impl.dart';

@GenerateMocks([RegisterUserClientService])
void main() {
  late RegisterUserRepositoryImpl registerUserRepository;
  late MockRegisterUserClientService mockRegisterUserClientService;

  setUp(() {
    mockRegisterUserClientService = MockRegisterUserClientService();
    registerUserRepository = RegisterUserRepositoryImpl(
        registerUserClientService: mockRegisterUserClientService);
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

  test("Deve retornar sucesso ao registrar usuário com dados válidos",
      () async {
    when(mockRegisterUserClientService.registerUser(
            registerUserModel: anyNamed("registerUserModel")))
        .thenAnswer((_) async => Result.success());

    final result =
        await registerUserRepository.registerUser(registerUserModel: validUser);

    expect(result.isSuccess, true);
    expect(result, isA<Result>());
  });

  test("Deve enviar os dados corretos para o serviço", () async {
    final expectedData = validUser.toJson(validUser);

    when(mockRegisterUserClientService.registerUser(
            registerUserModel: anyNamed("registerUserModel")))
        .thenAnswer((_) async => Result.success());

    await registerUserRepository.registerUser(registerUserModel: validUser);

    verify(mockRegisterUserClientService.registerUser(
      registerUserModel: expectedData,
    )).called(1);
  });

  test("Deve repropagar qualquer exceção do repository", () async {
    when(mockRegisterUserClientService.registerUser(
            registerUserModel: anyNamed("registerUserModel")))
        .thenThrow(Exception("Erro inesperado"));

    expect(
      () async => await registerUserRepository.registerUser(
          registerUserModel: validUser),
      throwsA(isA<Exception>()),
    );
  });

  test("Deve repropagar uma exceção personalizada (ServerException)", () async {
    when(mockRegisterUserClientService.registerUser(
            registerUserModel: anyNamed("registerUserModel")))
        .thenThrow(ServerException(message: "Erro no servidor"));

    expect(
      () async => await registerUserRepository.registerUser(
          registerUserModel: validUser),
      throwsA(isA<ServerException>()),
    );
  });
}
