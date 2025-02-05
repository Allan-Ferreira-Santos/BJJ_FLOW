import 'package:bjj_flow/core/domain/usecase.dart';

abstract class FutureUseCase<Input, Output> extends UseCase<Input, Future<Output>> {
  @override
  Future<Output> call([Input? input]);
}
