import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/utils/validators.dart';
import 'package:bjj_flow/core/domain/future_usecase.dart';
import 'package:bjj_flow/features/register_user/data/models/register_user_model.dart';
import 'package:bjj_flow/features/register_user/data/repositories/register_user_repository.dart';

class RegisterUserUseCase implements FutureUseCase<RegisterUserModel, Result> {
  final RegisterUserRepository registerUserRepository;

  RegisterUserUseCase({required this.registerUserRepository});

  @override
  Future<Result> call([RegisterUserModel? dataUser]) async {
    try {
      if (dataUser == null)  return Result.failure("Dados do usuário não podem ser nulos");

      final validationError = _validateDataUser(dataUser);

      if (validationError != null) return Result.failure(validationError);

      await registerUserRepository.registerUser(registerUserModel: dataUser);

      return Result.success();
    } catch (e) {
      rethrow;
    }
  }

  String? _validateDataUser(RegisterUserModel dataUser) {
    final errors = [
      Validators.name(dataUser.fullName),
      Validators.notEmpty(dataUser.userType, "Tipo de usuário"),
      Validators.notEmpty(dataUser.username, "Nome de usuário"),
      Validators.notEmpty(dataUser.gender, "Gênero"),
      Validators.phone(dataUser.phone),
      Validators.email(dataUser.email),
      Validators.cpf(dataUser.cpf),
      Validators.notEmpty(dataUser.addressId, "Endereço"),
      Validators.notEmpty(dataUser.graduationId, "Graduação"),
      Validators.notEmpty(dataUser.projectId, "Projeto"),
      Validators.notEmpty(dataUser.paymentId, "Pagamento"),
      Validators.futureDate(dataUser.registrationDate, "Data de registro"),
      Validators.dateRange(dataUser.registrationDate, dataUser.updateDate),
    ].whereType<String>().toList();

    return errors.isNotEmpty ? errors.first : null;
  }
}
