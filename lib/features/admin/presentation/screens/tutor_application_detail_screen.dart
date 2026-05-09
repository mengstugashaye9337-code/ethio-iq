import 'package:flutter/material.dart';
import 'package:ethio_iq/core/models/user_model.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/features/auth/data/auth_service.dart';
import 'package:ethio_iq/features/chat/presentation/screens/admin_tutor_chat_screen.dart';

class TutorApplicationDetailScreen extends StatelessWidget {
  final UserModel tutor;

  const TutorApplicationDetailScreen({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Tutor Application', style: AppTheme.titleMedium),
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Applicant Details', style: AppTheme.titleMedium),
            const SizedBox(height: AppTheme.spacingL),
            _buildDetailRow('Name', tutor.name),
            const SizedBox(height: AppTheme.spacingS),
            _buildDetailRow('Email', tutor.email),
            const SizedBox(height: AppTheme.spacingS),
            _buildDetailRow('Phone', tutor.phoneNumber ?? 'Not provided'),
            const SizedBox(height: AppTheme.spacingS),
            _buildDetailRow(
              'Applied',
              tutor.appliedAt != null
                  ? '${tutor.appliedAt!.toLocal()}'.split(' ').first
                  : 'Unknown',
            ),
            const SizedBox(height: AppTheme.spacingS),
            _buildDetailRow(
              'Verification Status',
              tutor.verificationStatus?.name ?? 'Pending',
            ),
            const SizedBox(height: AppTheme.spacingS),
            _buildDetailRow(
              'CV / Certificates',
              tutor.cvFileName ?? 'No documents uploaded yet',
            ),
            const SizedBox(height: AppTheme.spacingXL),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final updatedTutor = tutor.copyWith(
                        verificationStatus:
                            VerificationStatus.invited,
                      );
                      AuthService.updateUser(updatedTutor);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AdminTutorChatScreen(tutor: updatedTutor),
                        ),
                      );
                    },
                    style: AppTheme.elevatedButtonStyle,
                    child: Text('Invite to Exam', style: AppTheme.buttonText),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingL),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final updatedTutor = tutor.copyWith(
                        verificationStatus: VerificationStatus.active,
                      );
                      AuthService.updateUser(updatedTutor);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${tutor.name} is now active.',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    child: Text(
                      'Approve / Activate',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.paddingStandard),
          decoration: AppTheme.whiteCardDecoration,
          child: Text(value, style: AppTheme.bodyMedium),
        ),
      ],
    );
  }
}
