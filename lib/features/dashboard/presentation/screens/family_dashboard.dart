import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';
import 'package:ethio_iq/core/constants/app_constants.dart';
import 'package:ethio_iq/core/extensions/gradient_extension.dart';
import 'package:ethio_iq/core/models/user_model.dart';
import 'package:ethio_iq/features/tutor_profile/presentation/screens/tutor_list_screen.dart';
import 'package:ethio_iq/features/bookings/data/booking_repository.dart';
import 'package:ethio_iq/features/bookings/presentation/screens/my_requests_screen.dart';
import 'package:ethio_iq/features/subjects/presentation/screens/subject_library_screen.dart';
import 'package:ethio_iq/features/chat/presentation/screens/chat_screen.dart';

/// Family Dashboard - For Family/User role
///
/// Focuses on:
/// - Request a Tutor
/// - Subject Library
/// - My Requests
/// - Browse Tutors
class FamilyDashboard extends StatefulWidget {
  final UserModel user;

  const FamilyDashboard({super.key, required this.user});

  @override
  State<FamilyDashboard> createState() => _FamilyDashboardState();
}

class _FamilyDashboardState extends State<FamilyDashboard> {
  int _selectedIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildHomePage(context),
          _buildSubjectsPage(context),
          _buildRequestsPage(context),
          _buildProfilePage(context),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textSecondary,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomePage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            decoration: AppTheme.softBlueGradient.toBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selam, ${widget.user.name}!',
                            style: AppTheme.titleLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            'Ready to find the perfect tutor?',
                            style: AppTheme.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        '👨‍👩‍👧‍👦 Family',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Quick Actions
          Text('Quick Actions', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),

          // Request a Tutor Card
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
                    onPressed: () => _handleRequestTutor(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    child: Text(
                      'Submit Request',
                      style: AppTheme.buttonText.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Subject Library Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: AppTheme.cardDecoration,
                      child: const Icon(
                        Icons.library_books,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject Library', style: AppTheme.titleSmall),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Explore subjects and find tutors',
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
          ).addInkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubjectLibraryScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingL),

          // My Requests Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: AppTheme.cardDecoration,
                      child: const Icon(
                        Icons.assignment,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Requests', style: AppTheme.titleSmall),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Track your tutor requests',
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
          ).addInkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyRequestsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: AppTheme.spacingXL),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      conversationId: 'admin_${widget.user.id}',
                      otherUserId: 'admin',
                      otherUserName: 'Admin Team',
                      conversationType: 'family',
                      currentUserId: widget.user.id,
                      currentUserName: widget.user.name,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text('Message Admin'),
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),

          // Browse Tutors Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TutorListScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: Text('Browse All Tutors', style: AppTheme.buttonText),
              style: AppTheme.elevatedButtonStyle,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  Widget _buildSubjectsPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subjects', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'Browse the full subject library and select the right class for your student.',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: AppTheme.cardDecoration,
                      child: const Icon(
                        Icons.book,
                        color: AppTheme.primaryBlue,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject Library', style: AppTheme.titleSmall),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'From core subjects to extra skills, explore all options.',
                            style: AppTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SubjectLibraryScreen(),
                        ),
                      );
                    },
                    style: AppTheme.elevatedButtonStyle,
                    child: Text(
                      'Open Subject Library',
                      style: AppTheme.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Text('Top Subjects', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: const [
              Chip(label: Text('Mathematics')),
              Chip(label: Text('Science')),
              Chip(label: Text('English')),
              Chip(label: Text('Coding')),
              Chip(label: Text('Language Arts')),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  Widget _buildRequestsPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requests', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'Submit and track your tutor requests in one place.',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create a New Request', style: AppTheme.titleSmall),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Share subject, grade, and location so Ethio IQ can match a tutor.',
                  style: AppTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacingL),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _handleRequestTutor(context),
                    style: AppTheme.elevatedButtonStyle,
                    child: Text(
                      'Submit Tutor Request',
                      style: AppTheme.buttonText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('View Existing Requests', style: AppTheme.titleSmall),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Track status, review matches, and manage your service requests.',
                  style: AppTheme.bodySmall,
                ),
                const SizedBox(height: AppTheme.spacingL),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyRequestsScreen(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                    ),
                    child: Text('Open My Requests', style: AppTheme.buttonText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  Widget _buildProfilePage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingStandard),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: AppTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.paddingStandard),
            decoration: AppTheme.whiteCardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Account', style: AppTheme.titleSmall),
                const SizedBox(height: AppTheme.spacingS),
                Text('Name: ${widget.user.name}', style: AppTheme.bodyMedium),
                const SizedBox(height: AppTheme.spacingS),
                Text('Role: Family', style: AppTheme.bodyMedium),
                const SizedBox(height: AppTheme.spacingXL),
                Text(
                  'Profile management coming soon. For now, use the home tabs to manage your requests and explore subjects.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXL),
        ],
      ),
    );
  }

  /// Handle request tutor
  void _handleRequestTutor(BuildContext context) {
    _showTutorRequestDialog(context);
  }

  /// Handle bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
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
    BookingRepository.instance.createRequest(
      familyName: widget.user.name,
      subject: subject,
      grade: grade,
      location: location,
    );
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
}

/// Extension to add InkWell to Container
extension ContainerInkWell on Container {
  Widget addInkWell({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      child: this,
    );
  }
}
