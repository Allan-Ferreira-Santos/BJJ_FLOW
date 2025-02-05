import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/data/fb_reference.dart';
import 'package:bjj_flow/features/register_user/data/services/register_user_client_service.dart';

class RegisterUserClientServiceImpl implements RegisterUserClientService {
  final FbReference fbReference;

  RegisterUserClientServiceImpl({required this.fbReference});

  @override
  Future<Result> registerUser(
      {required Map<String, dynamic> registerUserModel}) async {
    try {
      await fbReference.registerUser.add(registerUserModel);
      return Result.success();
    } catch (e) {
      rethrow;
    }
  }
}
