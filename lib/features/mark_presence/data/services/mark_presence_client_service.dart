import 'package:bjj_flow/core/utils/result.dart';

abstract class MarkPresenceClientService {
  Future<Result> markPresence({required Map<String, dynamic> frequecyModel});
}