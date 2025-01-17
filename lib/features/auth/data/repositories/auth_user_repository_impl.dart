import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';
import 'package:bjj_flow/features/auth/data/repositories/auth_user_repository.dart';
import 'package:bjj_flow/features/auth/data/services/auth_user_client_service.dart';

class AuthUserRepositoryImpl extends AuthUserRepository {
  final AuthUserClientService authUserClientService;

  AuthUserRepositoryImpl({required this.authUserClientService});

  @override
  Future<Result<AuthUserModel>> signUp(
      {required String email, required String password}) async {
    try {
      final result =
          await authUserClientService.signUp(email: email, password: password);
      final userModel =
          AuthUserModel.fromJson(result.data as Map<String, dynamic>);
      return Result.success(userModel);
    } catch (e) {
      rethrow;
    }
  }
}
