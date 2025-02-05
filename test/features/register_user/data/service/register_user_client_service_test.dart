import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bjj_flow/core/data/fb_reference.dart';
import '../../../auth/data/service/auth_user_client_service_test.mocks.dart';
import 'package:bjj_flow/features/register_user/data/services/register_user_client_service_impl.dart';

@GenerateMocks([FbReference, CollectionReference, DocumentReference])
void main() {
  late MockFbReference mockFbReference;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late RegisterUserClientServiceImpl registerUserClientService;

  setUp(() {
    mockFbReference = MockFbReference();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();

    when(mockFbReference.registerUser).thenReturn(mockCollectionReference);
    when(mockCollectionReference.add(any))
        .thenAnswer((_) async => mockDocumentReference);

    registerUserClientService =
        RegisterUserClientServiceImpl(fbReference: mockFbReference);
  });

  final validUserData = {
    "userType": "1",
    "username": "name",
    "fullName": "name full",
    "gender": "gender",
    "birthDate": "2000-01-01",
    "phone": "99999999999",
    "email": "test@example.com",
    "cpf": "12345678900",
    "addressId": "addressId",
    "graduationId": "graduationId",
    "projectId": "projectId",
    "paymentId": "paymentId",
    "registrationDate": DateTime.now().toIso8601String(),
    "updateDate": DateTime.now().toIso8601String(),
  };

  test("Deve registrar usuário com sucesso", () async {
    final result = await registerUserClientService.registerUser(
        registerUserModel: validUserData);

    expect(result.isSuccess, true);
    verify(mockCollectionReference.add(validUserData)).called(1);
  });

  test("Deve retornar erro ao registrar usuário se houver falha no Firebase",
      () async {
    when(mockCollectionReference.add(any))
        .thenThrow(Exception("Erro no Firebase"));

    expectLater(
      () async => await registerUserClientService.registerUser(
          registerUserModel: validUserData),
      throwsA(isA<Exception>()),
    );

    verify(mockCollectionReference.add(validUserData)).called(1);
  });

  test("Deve chamar o método correto do Firebase com os dados corretos",
      () async {
    await registerUserClientService.registerUser(
        registerUserModel: validUserData);

    verify(mockFbReference.registerUser).called(1);
    verify(mockCollectionReference.add(validUserData)).called(1);
  });
}
