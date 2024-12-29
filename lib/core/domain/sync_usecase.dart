import 'package:bjj_flow/core/domain/usecase.dart';

abstract class SyncUsecase<Input, Output> extends Usecase<Input, Output> {
  @override
  Output call([Input? input]);
}
