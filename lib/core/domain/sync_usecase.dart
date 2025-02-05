import 'package:bjj_flow/core/domain/usecase.dart';

abstract class SyncUseCase<Input, Output> extends UseCase<Input, Output> {
  @override
  Output call([Input? input]);
}
