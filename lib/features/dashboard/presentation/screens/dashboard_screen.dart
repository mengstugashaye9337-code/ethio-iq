import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/features/tutor_profile/presentation/screens/tutor_profile_screen.dart';
import 'package:ethio_iq/features/bookings/presentation/screens/my_requests_screen.dart';

/// Dashboard Screen - Main hub after login
///
/// DATA FLOW:
/// 1. LoginScreen → passes userName via Navigator.push()
/// 2. We receive userName in constructor → display "Selam, $userName!"
/// 3. AppTheme.titleLarge → styles the greeting
/// 4. AppTheme.whiteCardDecoration → styles the Tutor Overview card
/// 5. "View Tutors" button → Navigator.push to TutorProfileScreen
/// 6. Bottom navigation handles tab switching
class DashboardScreen extends StatefulWidget {
  /// The user name passed from LoginScreen via Navigator
  final String userName;

  const DashboardScreen({super.key, required this.userName});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(AppConstants.appName, style: AppTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingStandard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // GREETING SECTION
            // ============================================
            /// Data Flow: userName variable flows from login → here
            /// We use AppTheme.titleLarge for consistent styling
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: AppTheme.softBlueGradient.toBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Selam, $userName!" - Ethiopian greeting
                  Text(
                    'Selam, ${widget.userName}!', // ← Data: userName flows here from LoginScreen
                    style: AppTheme.titleLarge.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Welcome to your learning journey',
                    style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // ============================================
            // REQUEST A TUTOR ACTION CARD
            // ============================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Request a Tutor',
                              style: AppTheme.titleMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            Text(
                              'Ethio IQ will match you with the perfect tutor',
                              style: AppTheme.bodyMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => _showTutorRequestDialog(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                      ),
                      child: Text(
                        'Submit Request',
                        style: AppTheme.buttonText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // ============================================
            // TUTOR OVERVIEW SECTION
            // ============================================
            /// Uses AppTheme.whiteCardDecoration as requested
            Text('Tutor Overview', style: AppTheme.titleMedium),
            const SizedBox(height: AppTheme.spacingL),

            // Tutor Overview Card - using whiteCardDecoration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: AppTheme.whiteCardDecoration, // ← From AppTheme
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon container with cardDecoration
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: AppTheme.cardDecoration,
                        child: const Icon(
                          Icons.school,
                          color: AppTheme.primaryBlue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingL),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Find a Tutor', style: AppTheme.titleSmall),
                            const SizedBox(height: AppTheme.spacingXS),
                            Text(
                              'Browse our qualified tutors',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Quick Stats - also using whiteCardDecoration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingStandard),
              decoration: AppTheme.whiteCardDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('12', 'Tutors', Icons.people),
                  _buildStatItem('5', 'Subjects', Icons.book),
                  _buildStatItem('2', 'Requests', Icons.assignment),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // ============================================
            // VIEW TUTORS BUTTON
            // ============================================
            /// This button navigates to TutorProfileScreen
            /// Uses AppTheme.elevatedButtonStyle - no hardcoded colors!
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _navigateToTutorProfile(context),
                icon: const Icon(Icons.search, color: Colors.white),
                label: Text('View Tutors', style: AppTheme.buttonText),
                style: AppTheme.elevatedButtonStyle,
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // ============================================
            // RECENT ACTIVITY SECTION
            // ============================================
            Text('Recent Activity', style: AppTheme.titleMedium),
            const SizedBox(height: AppTheme.spacingL),

            // Empty state card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: AppTheme.whiteCardDecoration,
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text('No recent activity', style: AppTheme.bodyMedium),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Your request history will appear here',
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tutors'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  /// ============================================
  /// NAVIGATOR.PUSH - Moving to Tutor Profile
  /// ============================================
  /// How it works:
  /// 1. User clicks "View Tutors" button
  /// 2. Navigator.push() adds TutorProfileScreen to the stack
  /// 3. Pass tutor data via constructor (name, subject, rating, price)
  /// 4. User can navigate back with back button or swipe
  void _navigateToTutorProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TutorProfileScreen(
          name: 'Dr. Alemayehu',
          subject: 'Mathematics',
          rating: 4.8,
          price: 500,
        ),
      ),
    );
  }

  /// Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Home - already here
        break;
      case 1:
        // Tutors
        _navigateToTutorProfile(context);
        break;
      case 2:
        // Requests
        _navigateToRequests(context);
        break;
      case 3:
        // Profile - placeholder
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile coming soon!')));
        break;
    }
  }

  /// Navigate to requests screen
  void _navigateToRequests(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyRequestsScreen()),
    );
  }

  /// Show tutor request dialog
  void _showTutorRequestDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final gradeController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request a Tutor', style: AppTheme.titleMedium),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    hintText: 'e.g., Mathematics, English, Science',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                TextField(
                  controller: gradeController,
                  decoration: InputDecoration(
                    labelText: 'Grade Level',
                    hintText: 'e.g., Grade 10, High School',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'e.g., Addis Ababa, Bole',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectController.text.isNotEmpty &&
                    gradeController.text.isNotEmpty &&
                    locationController.text.isNotEmpty) {
                  // Submit the request
                  _submitTutorRequest(
                    context,
                    subjectController.text,
                    gradeController.text,
                    locationController.text,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in all fields',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: AppTheme.warningColor,
                    ),
                  );
                }
              },
              style: AppTheme.elevatedButtonStyle,
              child: Text('Submit Request', style: AppTheme.buttonText),
            ),
          ],
        );
      },
    );
  }

  /// Submit tutor request
  void _submitTutorRequest(
    BuildContext context,
    String subject,
    String grade,
    String location,
  ) {
    // Here you would typically send the request to your backend
    // For now, we'll just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tutor request submitted! Ethio IQ will match you with the perfect tutor.',
          style: AppTheme.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
      ),
    );
  }

  /// Helper widget for stats
  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: AppTheme.cardDecoration,
          child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
        ),
        const SizedBox(height: AppTheme.spacingS),
        Text(
          value,
          style: AppTheme.titleMedium.copyWith(color: AppTheme.primaryBlue),
        ),
        Text(label, style: AppTheme.bodySmall),
      ],
    );
  }
}

// Remove duplicate extension - using shared one in core/extensions/
