import 'package:flutter/material.dart';
import 'package:ethio_iq/core/models/booking_request.dart';

/// In-memory booking repository for demo state sharing.
///
/// The Admin assigns a tutor here, and the family screen reads the same request state.
class BookingRepository {
  BookingRepository._internal();

  static final BookingRepository instance = BookingRepository._internal();

  final ValueNotifier<List<BookingRequest>> requests =
      ValueNotifier<List<BookingRequest>>([
        BookingRequest(
          id: 1,
          familyName: 'Kebede Family',
          subject: 'Mathematics',
          grade: 'Grade 10',
          location: 'Addis Ababa, Bole',
          requestDate: '2024-01-20',
          status: 'Pending',
          createdAt: DateTime.now(),
        ),
        BookingRequest(
          id: 2,
          familyName: 'Alemayehu Family',
          subject: 'Science',
          grade: 'Grade 9',
          location: 'Addis Ababa, Nifas Silk',
          requestDate: '2024-01-19',
          status: 'Pending',
          createdAt: DateTime.now(),
        ),
        BookingRequest(
          id: 3,
          familyName: 'Haile Family',
          subject: 'English',
          grade: 'High School',
          location: 'Dire Dawa',
          requestDate: '2024-01-18',
          status: 'Assigned',
          assignedTutor: 'Dr. Alemayehu',
          createdAt: DateTime.now(),
        ),
        BookingRequest(
          id: 4,
          familyName: 'Tadesse Family',
          subject: 'Coding',
          grade: 'High School',
          location: 'Addis Ababa, Gulale',
          requestDate: '2024-01-17',
          status: 'Pending',
          createdAt: DateTime.now(),
        ),
      ]);

  final List<String> tutors = [
    'Dr. Alemayehu',
    'Hana Bekele',
    'Meron Haile',
    'Sami Yusuf',
    'Abel Leul',
    'Mengstu Yaregal',
  ];

  List<BookingRequest> get pendingRequests =>
      requests.value.where((request) => request.isPending).toList();

  List<BookingRequest> get assignedRequests =>
      requests.value.where((request) => !request.isPending).toList();

  void assignTutor({
    required int requestId,
    required String tutorId,
    required String tutorName,
  }) {
    requests.value = requests.value.map((request) {
      if (request.id != requestId) return request;
      return request.copyWith(
        status: 'Assigned',
        assignedTutor: tutorName,
        assignedTutorId: tutorId,
      );
    }).toList();
  }

  BookingRequest? getRequestById(int requestId) {
    try {
      return requests.value.firstWhere((request) => request.id == requestId);
    } catch (_) {
      return null;
    }
  }

  BookingRequest createRequest({
    required String familyName,
    required String subject,
    required String grade,
    required String location,
  }) {
    final nextId = requests.value.isEmpty
        ? 1
        : requests.value.map((r) => r.id).reduce((a, b) => a > b ? a : b) + 1;
    final created = DateTime.now();
    final request = BookingRequest(
      id: nextId,
      familyName: familyName,
      subject: subject,
      grade: grade,
      location: location,
      requestDate: created.toIso8601String().split('T').first,
      status: 'Pending',
      createdAt: created,
    );
    requests.value = [...requests.value, request];
    return request;
  }
}
