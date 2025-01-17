import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/utils/validators.dart';
import 'package:bjj_flow/core/domain/future_usecase.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';
import 'package:bjj_flow/features/auth/data/repositories/auth_user_repository.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_email_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_password_exeption.dart';

class AuthUserUseCase implements FutureUsecase<String, Result<AuthUserModel>> {
  final AuthUserRepository authUserRepository;

  AuthUserUseCase({required this.authUserRepository});

  @override
  Future<Result<AuthUserModel>> call([String? email, String? password]) async {
    try {
      _validateEmailTextField(email);
      _validatePasswordTextField(password);

      return await authUserRepository.signUp(
          email: email!, password: password!);
    } catch (e) {
      rethrow;
    }
  }

  void _validateEmailTextField(String? email) {
    final result = Validators.email(email ?? "");
    if (result != null) throw InvalidEmailExeption(message: result);
  }

  void _validatePasswordTextField(String? password) {
    final result = Validators.password(password ?? "");
    if (result != null) throw InvalidPasswordExeption(message: result);
  }
}
