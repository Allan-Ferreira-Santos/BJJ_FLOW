import 'dart:async';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/domain/future_usecase.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/utils/exceptions/invalid_params_exception.dart';

class MarkPresenceViewModel {
  final MarkPresenceUsecase markPresenceUsecase;

  MarkPresenceViewModel({required this.markPresenceUsecase});

  final StreamController<Result> controllerMarkPresence =
      StreamController<Result>.broadcast();

  Stream<Result> get getMarkPresence => controllerMarkPresence.stream;

  Future<void> markPresence(FrequencyModel frequencyModel) async {
    controllerMarkPresence.add(Result.loading());
    try {
      final result = await markPresenceUsecase.call(frequencyModel);
      controllerMarkPresence.add(result);
    } catch (e) {
      controllerMarkPresence.add(Result.failure(e.toString()));
    }
  }

  void dispose() {
    controllerMarkPresence.close();
  }
}

class MarkPresenceUsecase implements FutureUsecase<FrequencyModel, Result> {
  final MarkPresenceRepository markPresenceRepository;

  MarkPresenceUsecase({required this.markPresenceRepository});

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

abstract class MarkPresenceRepository {
  Future<Result> markPresence({required FrequencyModel frequecyModel});
}

class MarkPresenceRepositoryImpl extends MarkPresenceRepository {
  @override
  Future<Result> markPresence({required FrequencyModel frequecyModel}) async {
    try {
      return Result.success();
    } catch (e) {
      rethrow;
    }
  }
}
