/// Booking request model for the Admin and Family flows.
class BookingRequest {
  final int id;
  final String familyName;
  final String subject;
  final String grade;
  final String location;
  final String requestDate;
  final String status;
  final String? assignedTutor;
  final String? assignedTutorId;
  final String? studentName;
  final String? specialInstructions;
  final DateTime createdAt;

  const BookingRequest({
    required this.id,
    required this.familyName,
    required this.subject,
    required this.grade,
    required this.location,
    required this.requestDate,
    required this.status,
    this.assignedTutor,
    this.assignedTutorId,
    this.studentName,
    this.specialInstructions,
    required this.createdAt,
  });

  bool get isPending => status == 'Pending';

  BookingRequest copyWith({
    String? status,
    String? assignedTutor,
    String? assignedTutorId,
    String? studentName,
    String? specialInstructions,
    DateTime? createdAt,
  }) {
    return BookingRequest(
      id: id,
      familyName: familyName,
      subject: subject,
      grade: grade,
      location: location,
      requestDate: requestDate,
      status: status ?? this.status,
      assignedTutor: assignedTutor ?? this.assignedTutor,
      assignedTutorId: assignedTutorId ?? this.assignedTutorId,
      studentName: studentName ?? this.studentName,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
