import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/domain/future_usecase.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';

class MarkPresenceUsecase implements FutureUsecase<FrequencyModel, Result> {
  @override
  Future<Result> call([FrequencyModel? input]) async {
    return Result.success();
  }
}
