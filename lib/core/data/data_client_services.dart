abstract class DataClientServices {
  Future<List<Map<String, dynamic>>> getAll(String resourcePath);
  Future<Map<String, dynamic>?> getById(String resourcePath, String id);
}