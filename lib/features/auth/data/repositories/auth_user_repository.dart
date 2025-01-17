import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';

abstract class AuthUserRepository {
  Future<Result<AuthUserModel>> signUp(
      {required String email, required String password});
}
