import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/features/auth/data/auth_service.dart';
import 'package:ethio_iq/features/bookings/data/booking_repository.dart';

class AssignTutorScreen extends StatelessWidget {
  final int requestId;

  const AssignTutorScreen({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final bookingRepository = BookingRepository.instance;
    final request = bookingRepository.getRequestById(requestId);
    final tutors = AuthService.registeredUsers
        .where((user) => user.role == UserRole.tutor)
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Assign Tutor', style: AppTheme.titleMedium),
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: request == null
          ? Center(
              child: Text('Request not found.', style: AppTheme.bodyMedium),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppTheme.spacingL),
                  Text('Request Details', style: AppTheme.titleLarge),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '${request.familyName} • ${request.subject} • ${request.grade}',
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  if (tutors.isEmpty) ...[
                    Text(
                      'No tutors are registered yet. Please register tutors first.',
                      style: AppTheme.bodyMedium,
                    ),
                  ] else ...[
                    Text(
                      'Select a tutor to assign:',
                      style: AppTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    Column(
                      children: tutors.map((tutor) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                            bottom: AppTheme.spacingL,
                          ),
                          padding: const EdgeInsets.all(
                            AppTheme.paddingStandard,
                          ),
                          decoration: AppTheme.whiteCardDecoration,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tutor.name, style: AppTheme.titleSmall),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                'Email: ${tutor.email}',
                                style: AppTheme.bodySmall,
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                'Phone: ${tutor.phoneNumber}',
                                style: AppTheme.bodySmall,
                              ),
                              const SizedBox(height: AppTheme.spacingL),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: AppTheme.elevatedButtonStyle,
                                  onPressed: () {
                                    bookingRepository.assignTutor(
                                      requestId: request.id,
                                      tutorId: tutor.id,
                                      tutorName: tutor.name,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Assigned ${tutor.name} to ${request.familyName}',
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: AppTheme.successColor,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Select',
                                    style: AppTheme.buttonText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
