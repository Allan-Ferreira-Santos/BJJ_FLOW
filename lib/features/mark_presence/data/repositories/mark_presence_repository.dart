import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';

abstract class MarkPresenceRepository {
  Future<Result> markPresence({required FrequencyModel frequecyModel});
}
