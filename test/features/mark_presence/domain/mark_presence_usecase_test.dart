import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'mark_presence_usecase_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/domain/mark_presence_usecase.dart';
import 'package:bjj_flow/features/mark_presence/utils/exceptions/invalid_params_exception.dart';
import 'package:bjj_flow/features/mark_presence/data/repositories/mark_presence_repository_impl.dart';


@GenerateMocks([MarkPresenceRepositoryImpl])
void main() {
  late MarkPresenceUseCase markPresenceUsecase;
  late MockMarkPresenceRepositoryImpl mockMarkPresenceRepositoryImpl;

  setUp(() {
    mockMarkPresenceRepositoryImpl = MockMarkPresenceRepositoryImpl();
    markPresenceUsecase = MarkPresenceUseCase(
        markPresenceRepository: mockMarkPresenceRepositoryImpl);
  });

  final frequencyModel = FrequencyModel(
    studentId: 'studentId',
    classId: 'classId',
    timestamp: DateTime.now(),
    markedBy: 'markedBy',
    status: 'status',
  );

  test("Deve retornar um result sucesso ao marcar a frequência", () async {
    when(mockMarkPresenceRepositoryImpl.markPresence(
            frequecyModel: anyNamed("frequecyModel")))
        .thenAnswer((_) async => Result.success());

    final result = await markPresenceUsecase.call(frequencyModel);

    expect(result.isSuccess, true);
    expect(result, isA<Result>());
  });

  test("Deve emitir um erro de parâmetros inválidos", () async {
    expect(
      () async => await markPresenceUsecase.call(null),
      throwsA(isA<InvalidParamsException>()),
    );
  });

  test("Deve repropagar qualquer exceção", () async {
    when(mockMarkPresenceRepositoryImpl.markPresence(
      frequecyModel: anyNamed("frequecyModel"),
    )).thenThrow(Exception("Algo deu errado"));

    await expectLater(
      () async => await markPresenceUsecase.call(frequencyModel),
      throwsA(isA<Exception>()),
    );
  });

  test("Deve retornar falha quando o repositório falhar", () async {
    when(mockMarkPresenceRepositoryImpl.markPresence(
      frequecyModel: anyNamed("frequecyModel"),
    )).thenAnswer((_) async => Result.failure("Erro no repositório"));

    final result = await markPresenceUsecase.call(frequencyModel);

    expect(result.isFailure, true);
    expect(result.error, "Erro no repositório");
  });

  test("Deve passar exceções lançadas no repositório para a usecase", () async {
    when(mockMarkPresenceRepositoryImpl.markPresence(
      frequecyModel: anyNamed("frequecyModel"),
    )).thenThrow(ServerException(message: "Falha no servidor"));

    expect(
      () async => await markPresenceUsecase.call(frequencyModel),
      throwsA(isA<ServerException>()),
    );
  });
}
