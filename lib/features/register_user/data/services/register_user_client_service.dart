import 'package:bjj_flow/core/utils/result.dart';

abstract class RegisterUserClientService {
  Future<Result> registerUser(
      {required Map<String, dynamic> registerUserModel});
}
