/// Client Request Model for Family Service Queue (FIFO)
class ClientRequest {
  final String id;
  final String familyName;
  final String familyEmail;
  final String subject;
  final String message;
  final DateTime createdAt;
  final String status;
  final int queueNumber;

  ClientRequest({
    required this.id,
    required this.familyName,
    required this.familyEmail,
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.status,
    required this.queueNumber,
  });

  Duration get waitDuration => DateTime.now().difference(createdAt);

  String get waitTimeString {
    final hours = waitDuration.inHours;
    final minutes = waitDuration.inMinutes % 60;

    if (hours > 0) {
      return 'Waiting $hours hour${hours > 1 ? 's' : ''} $minutes min';
    } else {
      return 'Waiting $minutes min';
    }
  }

  ClientRequest copyWith({
    String? id,
    String? familyName,
    String? familyEmail,
    String? subject,
    String? message,
    DateTime? createdAt,
    String? status,
    int? queueNumber,
  }) {
    return ClientRequest(
      id: id ?? this.id,
      familyName: familyName ?? this.familyName,
      familyEmail: familyEmail ?? this.familyEmail,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      queueNumber: queueNumber ?? this.queueNumber,
    );
  }
}
