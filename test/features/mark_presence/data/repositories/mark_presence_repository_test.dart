import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'mark_presence_repository_test.mocks.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/data/repositories/mark_presence_repository_impl.dart';
import 'package:bjj_flow/features/mark_presence/data/services/mark_presence_client_service_impl.dart';


@GenerateMocks([MarkPresenceClientServiceImpl])
void main() {
  late MarkPresenceRepositoryImpl markPresenceRepositoryImpl;
  late MockMarkPresenceClientServiceImpl mockMarkPresenceClientServiceImpl;

  setUp(() {
    mockMarkPresenceClientServiceImpl = MockMarkPresenceClientServiceImpl();
    markPresenceRepositoryImpl = MarkPresenceRepositoryImpl(
        markPresenceClientService: mockMarkPresenceClientServiceImpl);
  });

  final frequencyModel = FrequencyModel(
    studentId: 'studentId',
    classId: 'classId',
    timestamp: DateTime.now(),
    markedBy: 'markedBy',
    status: 'status',
  );

  test("Deve retornar sucesso ao enviar frequência com dados válidos",
      () async {
    when(mockMarkPresenceClientServiceImpl.markPresence(
            frequecyModel: anyNamed("frequecyModel")))
        .thenAnswer((_) async => Result.success());

    final result = await markPresenceRepositoryImpl.markPresence(
        frequecyModel: frequencyModel);

    expect(result.isSuccess, true);
    expect(result, isA<Result>());
  });

  test("Deve enviar os dados corretos para o serviço", () async {
    final expectedData = frequencyModel.toJson(frequencyModel);

    when(mockMarkPresenceClientServiceImpl.markPresence(
            frequecyModel: anyNamed("frequecyModel")))
        .thenAnswer((_) async => Result.success());

    await markPresenceRepositoryImpl.markPresence(
        frequecyModel: frequencyModel);

    verify(mockMarkPresenceClientServiceImpl.markPresence(
      frequecyModel: expectedData,
    )).called(1);
  });

  test("Deve repropagar qualquer exceção repository", () async {
    when(mockMarkPresenceClientServiceImpl.markPresence(
            frequecyModel: anyNamed("frequecyModel")))
        .thenThrow(Exception("Algo deu errado no repository"));

    expect(
      () async => await markPresenceRepositoryImpl.markPresence(
          frequecyModel: frequencyModel),
      throwsA(isA<Exception>()),
    );
  });

  test("Deve repropagar uma exceção personalizada", () async {
    when(mockMarkPresenceClientServiceImpl.markPresence(
            frequecyModel: anyNamed("frequecyModel")))
        .thenThrow(ServerException(message: "Erro no servidor"));

    expect(
      () async => await markPresenceRepositoryImpl.markPresence(
          frequecyModel: frequencyModel),
      throwsA(isA<ServerException>()),
    );
  });
}
