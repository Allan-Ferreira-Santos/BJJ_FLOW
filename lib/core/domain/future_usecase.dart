import 'package:bjj_flow/core/domain/usecase.dart';

abstract class FutureUsecase<Input, Output> extends Usecase<Input, Future<Output>> {
  @override
  Future<Output> call([Input? input]);
}
