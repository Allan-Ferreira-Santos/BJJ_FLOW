import 'package:bjj_flow/core/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bjj_flow/core/data/fb_reference.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/auth/data/services/auth_user_client_service.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_not_found_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_credencial_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_incorrect_password_exeption.dart';

class AuthUserClientServiceImpl implements AuthUserClientService {
  final FbReference fbReference;
  final FirebaseAuth firebaseAuth;

  AuthUserClientServiceImpl(
      {required this.fbReference, required this.firebaseAuth});

  @override
  Future<Result<Map<String, dynamic>>> signUp(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return Result.success({});
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-credential':
          throw InvalidCredencialExeption();
        case 'user-not-found':
          throw UserNotFoundExeptions();
        case 'wrong-password':
          throw UserIncorrectPasswordExeption();
        default:
          throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
