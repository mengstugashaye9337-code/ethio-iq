/// Tutor Application Model for Tutor Recruitment Queue (FIFO)
class TutorApplication {
  final String id;
  final String tutorName;
  final String tutorEmail;
  final String subject;
  final String experience;
  final String qualification;
  final DateTime appliedAt;
  final String status;
  final int queueNumber;

  TutorApplication({
    required this.id,
    required this.tutorName,
    required this.tutorEmail,
    required this.subject,
    required this.experience,
    required this.qualification,
    required this.appliedAt,
    required this.status,
    required this.queueNumber,
  });

  Duration get waitDuration => DateTime.now().difference(appliedAt);

  String get waitTimeString {
    final hours = waitDuration.inHours;
    final minutes = waitDuration.inMinutes % 60;

    if (hours > 0) {
      return 'Applied $hours hour${hours > 1 ? 's' : ''} $minutes min ago';
    } else {
      return 'Applied $minutes min ago';
    }
  }

  TutorApplication copyWith({
    String? id,
    String? tutorName,
    String? tutorEmail,
    String? subject,
    String? experience,
    String? qualification,
    DateTime? appliedAt,
    String? status,
    int? queueNumber,
  }) {
    return TutorApplication(
      id: id ?? this.id,
      tutorName: tutorName ?? this.tutorName,
      tutorEmail: tutorEmail ?? this.tutorEmail,
      subject: subject ?? this.subject,
      experience: experience ?? this.experience,
      qualification: qualification ?? this.qualification,
      appliedAt: appliedAt ?? this.appliedAt,
      status: status ?? this.status,
      queueNumber: queueNumber ?? this.queueNumber,
    );
  }
}
