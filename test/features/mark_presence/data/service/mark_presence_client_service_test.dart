import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bjj_flow/core/data/fb_reference.dart';
import 'mark_presence_client_service_test.mocks.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/data/services/mark_presence_client_service_impl.dart';

@GenerateMocks([
  FbReference,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>
])
void main() {
  late MarkPresenceClientServiceImpl markPresenceClientService;
  late MockFbReference mockFbReference;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;

  setUp(() {
    mockFbReference = MockFbReference();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();

    when(mockFbReference.markPresence).thenReturn(mockCollectionReference);

    when(mockCollectionReference.add(argThat(isA<Map<String, dynamic>>())))
        .thenAnswer((_) async => mockDocumentReference);

    markPresenceClientService =
        MarkPresenceClientServiceImpl(fbReference: mockFbReference);
  });

  final frequencyModel = FrequencyModel(
    studentId: 'studentId',
    classId: 'classId',
    timestamp: DateTime.now(),
    markedBy: 'markedBy',
    status: 'status',
  );

  final frequecyModelJson = frequencyModel.toJson(frequencyModel);

  test("Deve retornar sucesso ao enviar dados para o Firestore", () async {
    final result = await markPresenceClientService.markPresence(
        frequecyModel: frequecyModelJson);

    expect(result.isSuccess, true);
  });

  test("Deve enviar os dados corretos para o Firestore", () async {
    final expectedData = frequecyModelJson;

    await markPresenceClientService.markPresence(frequecyModel: expectedData);

    verify(mockCollectionReference.add(expectedData)).called(1);
  });

  test("Deve repropagar qualquer exceção", () async {
    when(mockCollectionReference.add(argThat(isA<Map<String, dynamic>>())))
        .thenThrow(Exception("Algo deu errado ao adicionar ao Firestore"));

    expect(
      () async => await markPresenceClientService.markPresence(
          frequecyModel: frequecyModelJson),
      throwsA(isA<Exception>()),
    );
  });

  test("Deve repropagar uma exceção personalizada", () async {
    when(mockCollectionReference.add(argThat(isA<Map<String, dynamic>>())))
        .thenThrow(FirebaseException(
            plugin: 'Firestore', message: 'Erro no Firestore'));

    expect(
      () async => await markPresenceClientService.markPresence(
          frequecyModel: frequecyModelJson),
      throwsA(isA<FirebaseException>()),
    );
  });
}
