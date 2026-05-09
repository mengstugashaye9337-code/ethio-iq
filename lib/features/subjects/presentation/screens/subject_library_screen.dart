import 'package:flutter/material.dart';
import 'package:ethio_iq/core/theme/app_theme.dart';

/// Subject Library Screen - Browse available subjects
///
/// DATA FLOW:
/// 1. DashboardScreen "5 Subjects" card → Navigator.push to here
/// 2. Displays subjects in two sections: Core & Beyond Curriculum
/// 3. Each subject card is tappable for filtering tutors
class SubjectLibraryScreen extends StatefulWidget {
  const SubjectLibraryScreen({super.key});

  @override
  State<SubjectLibraryScreen> createState() => _SubjectLibraryScreenState();
}

class _SubjectLibraryScreenState extends State<SubjectLibraryScreen> {
  // Core curriculum subjects
  final List<Map<String, dynamic>> curriculumSubjects = [
    {
      'name': 'Mathematics',
      'icon': Icons.calculate,
      'color': Color(0xFF6C8DFF),
    },
    {'name': 'Physics', 'icon': Icons.science, 'color': Color(0xFF10B981)},
    {
      'name': 'Chemistry',
      'icon': Icons.local_florist,
      'color': Color(0xFFF59E0B),
    },
    {'name': 'Biology', 'icon': Icons.biotech, 'color': Color(0xFFEF4444)},
    {'name': 'English', 'icon': Icons.language, 'color': Color(0xFF3B82F6)},
    {'name': 'History', 'icon': Icons.history_edu, 'color': Color(0xFF8B5CF6)},
    {'name': 'Geography', 'icon': Icons.public, 'color': Color(0xFF06B6D4)},
    {
      'name': 'Economics',
      'icon': Icons.trending_up,
      'color': Color(0xFFF97316),
    },
  ];

  // Beyond curriculum skills
  final List<Map<String, dynamic>> beyondCurriculumSkills = [
    {
      'name': 'Graphic Design',
      'icon': Icons.palette,
      'color': Color(0xFFEC4899),
    },
    {'name': 'Coding', 'icon': Icons.code, 'color': Color(0xFF14B8A6)},
    {
      'name': 'Web Development',
      'icon': Icons.language,
      'color': Color(0xFF0891B2),
    },
    {'name': 'Music', 'icon': Icons.music_note, 'color': Color(0xFF7C3AED)},
    {'name': 'Public Speaking', 'icon': Icons.mic, 'color': Color(0xFFDC2626)},
    {'name': 'Leadership', 'icon': Icons.people, 'color': Color(0xFF059669)},
  ];

  String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text('Subject Library', style: AppTheme.titleMedium),
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
            Text('Core Curriculum', style: AppTheme.titleLarge),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Browse certified tutors for academic subjects',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Core subjects grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingL,
                mainAxisSpacing: AppTheme.spacingL,
              ),
              itemCount: curriculumSubjects.length,
              itemBuilder: (context, index) {
                final subject = curriculumSubjects[index];
                return _buildSubjectCard(subject);
              },
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Beyond Curriculum Section
            Text('Beyond Curriculum', style: AppTheme.titleLarge),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Develop skills and talents with expert trainers',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Beyond curriculum skills grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingL,
                mainAxisSpacing: AppTheme.spacingL,
              ),
              itemCount: beyondCurriculumSkills.length,
              itemBuilder: (context, index) {
                final skill = beyondCurriculumSkills[index];
                return _buildSubjectCard(skill);
              },
            ),

            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }

  /// Build subject card with visual design
  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final isSelected = selectedSubject == subject['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSubject = subject['name'];
        });
        // Navigate to request match form with subject pre-filled
        _navigateToRequestMatch(subject['name']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? subject['color']
              : (subject['color'] as Color).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: isSelected
              ? Border.all(color: subject['color'], width: 2)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (subject['color'] as Color).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              subject['icon'],
              size: 40,
              color: isSelected ? Colors.white : subject['color'],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              subject['name'],
              textAlign: TextAlign.center,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to request match form with subject pre-filled
  void _navigateToRequestMatch(String subject) {
    final gradeController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Request a Tutor Match', style: AppTheme.titleMedium),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pre-filled subject
                Container(
                  padding: const EdgeInsets.all(AppTheme.paddingStandard),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.subject, color: AppTheme.primaryBlue),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subject',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              subject,
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                const SizedBox(height: AppTheme.spacingL),
                Text(
                  'Note: In Ethiopia, one tutor covers all subjects. We\'ll match you with the best available tutor for your needs.',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
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
                if (gradeController.text.isNotEmpty &&
                    locationController.text.isNotEmpty) {
                  _submitTutorRequest(
                    context,
                    subject,
                    gradeController.text,
                    locationController.text,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please fill in grade level and location',
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
              child: Text('Request Match', style: AppTheme.buttonText),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tutor match request submitted for $subject! Ethio IQ will find the perfect tutor for you.',
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
