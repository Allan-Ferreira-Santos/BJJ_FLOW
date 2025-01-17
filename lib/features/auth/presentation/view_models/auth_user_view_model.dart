import 'dart:async';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/utils/exceptions/server_exception.dart';
import 'package:bjj_flow/features/auth/domain/auth_user_usecase.dart';
import 'package:bjj_flow/features/auth/data/models/auth_user_model.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_email_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_not_found_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/invalid_password_exeption.dart';
import 'package:bjj_flow/features/auth/utils/exceptions/user_incorrect_password_exeption.dart';

class AuthUserViewModel {
  final AuthUserUseCase authUserUsecase;

  AuthUserViewModel({required this.authUserUsecase});

  final StreamController<Result<AuthUserModel>> authUserController =
      StreamController<Result<AuthUserModel>>.broadcast();

  Stream<Result<AuthUserModel>> get authUserStream => authUserController.stream;

  bool _isVisiblePassword = false;

  bool get isVisiblePassword => _isVisiblePassword;

  Future<AuthUserModel?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      authUserController.add(Result.loading());

      final result = await authUserUsecase.call(email, password);

      authUserController.add(result);
      return result.data;
    } catch (e) {
      final errorMessage = _handleError(e);
      authUserController.add(Result.failure(errorMessage));
      return null;
    }
  }

  String _handleError(Object e) {
    if (e is InvalidEmailExeption) {
      return e.message;
    }
    if (e is UserNotFoundExeptions) {
      return "User not found.";
    }
    if (e is UserIncorrectPasswordExeption) {
      return "password is incorrect";
    }
    if (e is ServerException) {
      return "Internal server error. Please try again later.";
    }
    if (e is InvalidPasswordExeption) {
      return e.message;
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }

  void togglePasswordVisibility() {
    _isVisiblePassword = !_isVisiblePassword;
  }

  void dispose() {
    if (!authUserController.isClosed) {
      authUserController.close();
    }
  }
}
