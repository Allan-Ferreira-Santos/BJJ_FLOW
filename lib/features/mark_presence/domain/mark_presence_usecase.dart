import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/domain/future_usecase.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/utils/exceptions/invalid_params_exception.dart';
import 'package:bjj_flow/features/mark_presence/data/repositories/mark_presence_repository.dart';

class MarkPresenceUseCase implements FutureUseCase<FrequencyModel, Result> {
  final MarkPresenceRepository markPresenceRepository;

  MarkPresenceUseCase({required this.markPresenceRepository});

  @override
  Future<Result> call([FrequencyModel? frequencyModel]) async {
    try {
      _validateFrequencyModel(frequencyModel);
      return await markPresenceRepository.markPresence(
          frequecyModel: frequencyModel!);
    } catch (e) {
      rethrow;
    }
  }

  void _validateFrequencyModel(FrequencyModel? frequencyModel) {
    if (frequencyModel == null) {
      throw InvalidParamsException();
    }
  }
}
