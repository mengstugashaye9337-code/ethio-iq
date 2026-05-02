import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';

/// My Requests Screen - Shows Service Requests (Concierge Matching)
///
/// DATA FLOW:
/// 1. DashboardScreen → Navigator.push to here via bottom nav
/// 2. Displays list of service requests with status
/// 3. Uses AppTheme colors for status indicators
/// 4. Pending: warningColor, Assigned: successColor
class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('My Service Requests', style: AppTheme.titleMedium),
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
            const SizedBox(height: AppTheme.spacingL),

            // Header
            Text('Your Tutor Requests', style: AppTheme.titleLarge),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Ethio IQ concierge matching system',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Service Requests List
            _buildServiceRequestCard(
              subject: 'Grade 10 Mathematics',
              status: 'Pending',
              description: 'Ethio IQ is finding your perfect match.',
              requestedDate: '2024-01-15',
            ),
            const SizedBox(height: AppTheme.spacingL),

            _buildServiceRequestCard(
              subject: 'High School English',
              status: 'Assigned',
              description:
                  'Tutor Assigned: Dr. Alemayehu. Ethio IQ has verified this match.',
              requestedDate: '2024-01-10',
              tutorName: 'Dr. Alemayehu',
            ),
            const SizedBox(height: AppTheme.spacingL),

            _buildServiceRequestCard(
              subject: 'Grade 8 Science',
              status: 'Pending',
              description: 'Ethio IQ is finding your perfect match.',
              requestedDate: '2024-01-08',
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: AppTheme.grayCardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryBlue,
                    size: 32,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'How Concierge Matching Works',
                    style: AppTheme.titleSmall.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    '1. Submit your request with subject and grade level\n'
                    '2. Ethio IQ reviews and matches with qualified tutors\n'
                    '3. Receive notification when tutor is assigned\n'
                    '4. Start learning with your verified match',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build service request card
  Widget _buildServiceRequestCard({
    required String subject,
    required String status,
    required String description,
    required String requestedDate,
    String? tutorName,
  }) {
    final isPending = status == 'Pending';
    final statusColor = isPending
        ? AppTheme.warningColor
        : AppTheme.successColor;
    final statusIcon = isPending ? Icons.schedule : Icons.check_circle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      decoration: AppTheme.whiteCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(subject, style: AppTheme.titleMedium)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 16),
                    const SizedBox(width: AppTheme.spacingXS),
                    Text(
                      status,
                      style: AppTheme.bodySmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(description, style: AppTheme.bodyMedium),
          const SizedBox(height: AppTheme.spacingS),
          Text('Requested: $requestedDate', style: AppTheme.bodySmall),
          if (tutorName != null) ...[
            const SizedBox(height: AppTheme.spacingS),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: AppTheme.successColor, size: 20),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Assigned Tutor: $tutorName',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
