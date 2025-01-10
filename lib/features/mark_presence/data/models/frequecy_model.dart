class FrequencyModel {
  final String id;
  final String studentId;
  final String classId;
  final DateTime timestamp;
  final String markedBy;
  final String status;

  FrequencyModel({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.timestamp,
    required this.markedBy,
    required this.status,
  });
}
