import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';

/// Tutor Profile Screen - Shows tutor details
///
/// DATA FLOW:
/// 1. DashboardScreen → calls Navigator.push to here
/// 2. Receives tutor data via constructor (name, subject, rating, price)
/// 3. Displays tutor info using AppTheme constants
/// 4. Has "Book Now" button to return to dashboard
class TutorProfileScreen extends StatelessWidget {
  final String name;
  final String subject;
  final double rating;
  final int price;

  const TutorProfileScreen({
    super.key,
    required this.name,
    required this.subject,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Tutor Profile', style: AppTheme.titleMedium),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppTheme.spacingL),

            // Top Logo Section
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 56),
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Tutor Information
            /// Uses AppTheme.titleLarge - no hardcoded styles!
            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: AppTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Center(
              child: Text(
                subject,
                textAlign: TextAlign.center,
                style: AppTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingS,
                ),
                decoration: AppTheme.cardDecoration,
                child: Text(
                  '⭐ $rating Rating',
                  style: AppTheme.titleSmall.copyWith(
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Description Card
            /// Uses AppTheme.cardDecoration - no hardcoded colors!
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.cardDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: AppTheme.titleSmall),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Experienced tutor with over 5 years of teaching $subject. '
                    'Passionate about helping students achieve their academic goals.',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Price Card
            /// Uses AppTheme.grayCardDecoration - no hardcoded colors!
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.grayCardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Session Price', style: AppTheme.bodyMedium),
                  Text(
                    'ETB $price',
                    style: AppTheme.titleMedium.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Concierge Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
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
                    'Ethio IQ Concierge Matching',
                    style: AppTheme.titleSmall.copyWith(
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Ethio IQ handles all matching to ensure quality. Go to your Dashboard to request a tutor.',
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }
}
