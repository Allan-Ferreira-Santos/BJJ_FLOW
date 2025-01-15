import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bjj_flow/core/utils/result.dart';
import 'mark_presence_view_model_test.mocks.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/domain/mark_presence_usecase.dart';
import 'package:bjj_flow/features/mark_presence/presentation/view_models/mark_presence_view_model.dart';


@GenerateMocks([MarkPresenceUsecase])
void main() {
  late MarkPresenceViewModel markPresenceViewModel;
  late MockMarkPresenceUsecase mockMarkPresenceUsecase;

  setUp(() {
    mockMarkPresenceUsecase = MockMarkPresenceUsecase();
    markPresenceViewModel =
        MarkPresenceViewModel(markPresenceUsecase: mockMarkPresenceUsecase);
  });

  final frequencyModel = FrequencyModel(
    studentId: 'studentId',
    classId: 'classId',
    timestamp: DateTime.now(),
    markedBy: 'markedBy',
    status: 'status',
  );

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

  test('Deve emitir loading e success ao marcar presença com sucesso',
      () async {
    when(mockMarkPresenceUsecase.call(any))
        .thenAnswer((_) async => Result.success());

    expectLater(
      markPresenceViewModel.getMarkPresence,
      emitsInOrder([
        resultMatcher(Result.loading()),
        resultMatcher(Result.success()),
      ]),
    );

    await markPresenceViewModel.markPresence(frequencyModel);
  });

  test("Deve emitir um loading e um failure ao tentar marcar a presencaça",
      () async {
    when(mockMarkPresenceUsecase.call(any)).thenAnswer((_) async =>
        Result.failure("Error ao marcar presenca , tente novamente"));

    expectLater(
        markPresenceViewModel.getMarkPresence,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(
              Result.failure("Error ao marcar presenca , tente novamente")),
        ]));

    await markPresenceViewModel.markPresence(frequencyModel);
  });

  test("Deve emitir um loading e failure ao lançar exceção inesperada",
      () async {
    when(mockMarkPresenceUsecase.call(any))
        .thenThrow(Exception("Algo deu errado aqui"));

    expectLater(
        markPresenceViewModel.getMarkPresence,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(Result.failure("Exception: Algo deu errado aqui")),
        ]));

    await markPresenceViewModel.markPresence(frequencyModel);
  });

  test("Deve fechar o StreamController quando dispose for chamado", () async {
    markPresenceViewModel.dispose();

    expect(markPresenceViewModel.controllerMarkPresence.isClosed, true);
  });

  test("Deve emitir loading e failure se FrequencyModel for inválido",
      () async {
    final invalidModel = FrequencyModel(
      studentId: '',
      classId: '',
      timestamp: DateTime.now(),
      markedBy: '',
      status: '',
    );

    when(mockMarkPresenceUsecase.call(any))
        .thenAnswer((_) async => Result.failure("Modelo inválido"));

    expectLater(
        markPresenceViewModel.getMarkPresence,
        emitsInOrder([
          resultMatcher(Result.loading()),
          resultMatcher(Result.failure("Modelo inválido")),
        ]));

    await markPresenceViewModel.markPresence(invalidModel);
  });
}
