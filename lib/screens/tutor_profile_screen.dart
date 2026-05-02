import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

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
      appBar: AppBar(title: const Text('Ethio IQ')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

            const SizedBox(height: 18),

            // Tutor Information
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
              child: Text(
                '⭐ $rating Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Description Card
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: AppTheme.cardDecoration,
              child: const Text(
                'I am Mengstu Ethio IQ tutors help students in all subjects including Math, English, Science, and more. We connect families with qualified tutors across Ethiopia.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppTheme.textDark,
                ),
              ),
            ),

            const Spacer(),

            // Bottom Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        tutorName: name,
                        subject: subject,
                        rating: rating,
                        pricePerHour: price,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Tutor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
          ],
        ),
      ),
    );
  }
}
