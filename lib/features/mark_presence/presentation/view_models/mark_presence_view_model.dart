import 'dart:async';
import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/domain/mark_presence_usecase.dart';

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
