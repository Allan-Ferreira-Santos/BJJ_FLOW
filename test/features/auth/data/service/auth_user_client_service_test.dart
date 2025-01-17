import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_user_client_service_test.mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bjj_flow/core/data/fb_reference.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_not_found_exeption.dart';
import 'package:bjj_flow/features/auth/data/services/auth_user_client_service_impl.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_credencial_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_incorrect_password_exeption.dart';

@GenerateMocks([
  FbReference,
  CollectionReference,
  DocumentReference,
  FirebaseAuth,
  UserCredential
])
void main() {
  late MockFbReference mockFbReference;
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthUserClientServiceImpl authService;

  setUp(() {
    mockFbReference = MockFbReference();
    mockFirebaseAuth = MockFirebaseAuth();
    authService = AuthUserClientServiceImpl(
      fbReference: mockFbReference,
      firebaseAuth: mockFirebaseAuth,
    );
  });

  group('signUp', () {
    const email = 'test@example.com';
    const password = 'password123';

    test('should return success when sign-in is successful', () async {
      final mockUserCredential = MockUserCredential();

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.signUp(email: email, password: password);

      expect(result.data, isA<Map<String, dynamic>>());
    });

    test('should throw InvalidCredencialExeption on invalid-credential error',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'invalid-credential'));

      expect(() => authService.signUp(email: email, password: password),
          throwsA(isA<InvalidCredencialExeption>()));
    });

    test('should throw UserNotFoundExeptions on user-not-found error',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(() => authService.signUp(email: email, password: password),
          throwsA(isA<UserNotFoundExeptions>()));
    });

    test('should throw UserIncorrectPasswordExeption on wrong-password error',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(() => authService.signUp(email: email, password: password),
          throwsA(isA<UserIncorrectPasswordExeption>()));
    });

    test('should throw ServerException on unknown error', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenThrow(FirebaseAuthException(code: 'unknown-error'));

      expect(() => authService.signUp(email: email, password: password),
          throwsA(isA<ServerException>()));
    });
  });
}
