import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';

abstract class RegisterUserRepository {
  Future<Result> registerUser({required RegisterUserModel registerUserModel});
}
