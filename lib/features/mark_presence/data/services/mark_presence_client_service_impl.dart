import 'package:bjj_flow/core/utils/result.dart';
import 'package:bjj_flow/core/data/fb_reference.dart';
import 'package:bjj_flow/features/mark_presence/data/services/mark_presence_client_service.dart';

class MarkPresenceClientServiceImpl implements MarkPresenceClientService {
  final FbReference fbReference;

  MarkPresenceClientServiceImpl({required this.fbReference});

  @override
  Future<Result> markPresence(
      {required Map<String, dynamic> frequecyModel}) async {
    try {
      await fbReference.markPresence.add(frequecyModel);

      return Result.success();
    } catch (e) {
      rethrow;
    }
  }
}
