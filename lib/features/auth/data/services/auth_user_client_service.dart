import 'package:bjj_flow/core/utils/result.dart';

abstract class AuthUserClientService {
  Future<Result<Map<String, dynamic>>> signUp(
      {required String email, required String password});
}
