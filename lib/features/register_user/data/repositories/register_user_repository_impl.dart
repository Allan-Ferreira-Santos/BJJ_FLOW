import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';
import 'package:bjj_flow/features/register_user/data/repositories/register_user_repository.dart';
import 'package:bjj_flow/features/register_user/data/services/register_user_client_service.dart';

class RegisterUserRepositoryImpl implements RegisterUserRepository {
  final RegisterUserClientService registerUserClientService;

  RegisterUserRepositoryImpl({required this.registerUserClientService});

  @override
  Future<Result> registerUser(
      {required RegisterUserModel registerUserModel}) async {
    try {
      Map<String, dynamic> data = registerUserModel.toJson(registerUserModel);
      return await registerUserClientService.registerUser(
          registerUserModel: data);
    } catch (e) {
      rethrow;
    }
  }
}
