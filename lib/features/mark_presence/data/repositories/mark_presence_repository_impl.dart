import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/features/mark_presence/data/models/frequecy_model.dart';
import 'package:bjj_flow/features/mark_presence/data/repositories/mark_presence_repository.dart';
import 'package:bjj_flow/features/mark_presence/data/services/mark_presence_client_service.dart';

class MarkPresenceRepositoryImpl extends MarkPresenceRepository {
  final MarkPresenceClientService markPresenceClientService;

  MarkPresenceRepositoryImpl({required this.markPresenceClientService});

  @override
  Future<Result> markPresence({required FrequencyModel frequecyModel}) async {
    try {
      Map<String, dynamic> data = frequecyModel.toJson(frequecyModel);
      return await markPresenceClientService.markPresence(frequecyModel: data);
    } catch (e) {
      rethrow;
    }
  }
}
