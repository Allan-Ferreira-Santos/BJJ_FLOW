import 'dart:async';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/register_user/domain/register_user_usecase.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';

class RegisterUserViewModel {
  final RegisterUserUseCase registerUserUsecase;

  RegisterUserViewModel({required this.registerUserUsecase});

  final StreamController<Result<void>> controllerRegisterUser =
      StreamController.broadcast();

  Stream<Result<void>> get registerUserStream => controllerRegisterUser.stream;

  Future<void> registerUser(RegisterUserModel registerUserModel) async {
    controllerRegisterUser.add(Result.loading());
    try {
      final result = await registerUserUsecase.call(registerUserModel);
      controllerRegisterUser.add(result);
    } catch (e) {
      controllerRegisterUser.add(Result.failure(e.toString()));
    }
  }

  void dispose() {
    controllerRegisterUser.close();
  }
}
